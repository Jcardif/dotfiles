# .NET 10 Auth Upgrade Audit

No ASP.NET Core app, auth config, or source files were provided in the workspace for this eval, so I cannot do a file-level audit or prove that the current setup is safe or unsafe. This is therefore a security and upgrade audit of the areas you asked about, focused on the regressions that matter after a move to .NET 10.

## Overall verdict

I do not see evidence of a concrete security regression because there is no concrete config to inspect. The main thing .NET 10 changes here is behavior, not baseline security posture: cookie auth for known API endpoints now returns `401`/`403` instead of redirecting to login or access-denied pages. That is usually the correct outcome for APIs, but it can look like a break after upgrade if the app was relying on redirect behavior.

The highest-risk areas to review in a real app are:

- global cookie policies that break OIDC nonce or correlation cookies
- `SaveTokens = true` with cookie-backed sessions when there is no strong reason to persist tokens client-side
- permissive credentialed CORS
- passkey deployment without an explicit relying party domain or trusted host-header validation

## Cookies

- Session cookies should still be locked down with `HttpOnly = true` and `SecurePolicy = Always`.
- Be careful with `SameSite`. OIDC uses cross-site redirects and form posts, so globally forcing `SameSite=Strict` or even `Lax` can break nonce and correlation cookies. For cross-site auth flows, `SameSite=None` must also be `Secure`.
- If the app exposes APIs and uses cookie auth, the .NET 10 change from redirects to `401`/`403` for known API endpoints is not a security regression. It is a breaking behavior change you need to account for in clients and tests.
- If the app runs on multiple nodes, persist and share Data Protection keys. Otherwise valid auth cookies can become unreadable after restarts or on other instances.

## OpenID Connect

- The expected baseline is still authorization code flow over HTTPS, typically with PKCE enabled.
- Pushed Authorization Requests (PAR) became the default when the identity provider supports them. If sign-in started failing after the upgrade, check whether the provider correctly supports PAR before disabling it.
- If the app calls the UserInfo endpoint, map nonstandard claims explicitly. Otherwise claims can silently disappear even though authentication still succeeds.
- Do not keep OIDC client secrets in `appsettings.json`. Store them in a proper secret store.
- Review `SaveTokens = true` carefully. With a cookie sign-in scheme, that commonly means access, ID, and sometimes refresh tokens are serialized into the authenticated session. That increases cookie size and increases the blast radius if the session cookie is stolen.

## Passkeys

- Built-in .NET 10 passkey support is scoped to ASP.NET Core Identity. It is not a general-purpose WebAuthn platform you can drop onto any auth architecture.
- The current built-in support has real limitations: no default attestation validation, template support is narrow, and passkeys are treated as a primary authentication factor rather than built-in second-factor auth.
- The nastiest deployment footgun is relying party identity. If `ServerDomain` is not set, Identity derives the relying party ID from the request `Host` header. That is only safe if your hosting layer strictly validates host headers. If it does not, you have a real security problem.
- If you adopt passkeys, treat recovery as part of the security design. Users need backup sign-in paths, multiple registered passkeys, and account recovery that is not trivial to abuse.

## CORS

- CORS is not an auth mechanism or a security boundary. It is a browser policy control.
- Never combine `AllowAnyOrigin` with credentials. ASP.NET Core documents that combination as insecure and rejects it because it can enable cross-site request forgery.
- For cookie-authenticated frontends, allow only explicit trusted origins. Do not use a global wildcard policy and call it a day.
- Keep CORS middleware in the correct order so auth failures still include the expected CORS headers. In endpoint-routing apps, that means after routing and before authorization.

## Bottom line

With no actual app config to inspect, I cannot say that the current setup has a confirmed security regression. I can say what I would treat as likely upgrade regressions in a real .NET 10 app:

1. API clients or frontend code assuming cookie auth still redirects instead of returning `401`/`403`.
2. OIDC flows broken by an overzealous global cookie or `SameSite` policy.
3. Tokens being unnecessarily stored in the auth session via `SaveTokens = true`.
4. Credentialed CORS policies that are broader than the trusted frontend origins.
5. Passkeys enabled without an explicit relying party domain and without trusted host-header enforcement.

If you want a real audit instead of a standards-based one, the missing inputs are the auth registration code, cookie policy, OIDC options, CORS policy, and any Identity or passkey setup.

## Sources

- [What’s new in ASP.NET Core for .NET 10](https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-10.0?view=aspnetcore-10.0)
- [Configure OpenID Connect Web authentication in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/configure-oidc-web-authentication?view=aspnetcore-9.0)
- [Claims mapping with OpenID Connect in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/claims?view=aspnetcore-9.0)
- [Work with SameSite cookies in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/samesite?view=aspnetcore-9.0)
- [Enable passkeys in ASP.NET Core Blazor](https://learn.microsoft.com/en-us/aspnet/core/blazor/security/passkeys?view=aspnetcore-10.0)
- [CORS in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/cors?view=aspnetcore-9.0)
