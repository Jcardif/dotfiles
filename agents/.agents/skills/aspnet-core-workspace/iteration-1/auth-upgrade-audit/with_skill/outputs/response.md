<!-- markdownlint-disable MD013 -->

# Auth Upgrade Audit

No source files or configuration were provided, so I can't honestly tell you whether the current app already has a regression. What I can do is audit this as a .NET 10 auth and security review, call out the places most likely to break during the upgrade, and tell you what would count as a regression once the actual `Program.cs`, auth options, and app settings exist.

## Overall read

This should be treated as a security and upgrade audit, not a rewrite. Based on current ASP.NET Core guidance, the highest-risk areas after a .NET 10 auth upgrade are:

- Cookie behavior changes at API endpoints
- SameSite interactions between cookies and OIDC redirects
- Over-assuming what built-in passkeys do in .NET 10
- Broad or misordered CORS policies

There is no evidence here that the app is currently secure or insecure, because there is no app here to inspect. Anyone claiming otherwise is doing performance art.

## Cookies

Primary checks:

- Authentication cookies should still be `Secure`, `HttpOnly`, and use explicit lifetime/sliding-expiration rules appropriate to the app.
- Data protection key storage must be durable and shared correctly in multi-instance deployments, otherwise existing auth cookies become unreadable or unpredictable after deploys.
- If the app mixes browser pages and APIs, verify whether the new .NET 10 behavior is acceptable: cookie-authenticated known API endpoints now return `401`/`403` instead of redirecting to login or access denied pages.

Upgrade-specific risk:

- A global cookie policy or a blanket `SameSite` override can break OIDC. Microsoft documents cookie auth as defaulting to `Lax`, while remote auth correlation cookies and OIDC nonce cookies use `SameSite=None`. If someone "tightened" cookies globally during the upgrade, that can silently break sign-in callbacks.

What I would flag as a regression:

- Auth cookies downgraded from `Secure`
- Shared hosting or web farm deployments without stable data protection key persistence
- API callers unexpectedly getting redirects before the upgrade and `401`/`403` after the upgrade, or the reverse if custom overrides were added badly
- Global `SameSite=Lax` or `Strict` applied to OIDC-related cookies

## OIDC

Primary checks:

- The OIDC handler must sign in through a cookie-capable scheme. Microsoft’s guidance still shows the sign-in scheme using the cookie authentication scheme.
- Callback, signed-out callback, and remote sign-out paths must match the identity provider registration exactly. Drift here is the classic "works locally, dies in prod" move.
- Authorization code flow should remain the baseline. If the upgrade reintroduced implicit or hybrid behavior, that would be a step backward.
- Claims mapping should be reviewed deliberately. Current guidance notes that `MapInboundClaims = false` is required for most OIDC providers.

Upgrade-specific risk:

- If the app uses `SaveTokens = true` for refresh-token storage, that is not automatically wrong, but it increases the importance of strong cookie protection, data protection key management, and session revocation controls. That is an inference from the documented behavior, not proof of a bug in this repo.

What I would flag as a regression:

- Callback URIs no longer aligned with provider registration
- Wrong sign-in scheme or scheme-name drift between registration and usage
- Token handling changed during the upgrade without reviewing cookie size, persistence, or revocation behavior
- Claims mapping changed and authorization started depending on renamed claims by accident

## Passkeys

This is the .NET 10 area people are most likely to oversell.

Current Microsoft guidance is explicit:

- Built-in passkeys are scoped to ASP.NET Core Identity
- They are not a general-purpose WebAuthn stack
- There is no default attestation validation
- Template support is limited to the Blazor Web App template
- Built-in passkeys are treated as a primary authentication factor, not built-in 2FA

What I would flag as a regression:

- Assuming passkeys can just be dropped into a non-Identity app
- Assuming passkeys replace MFA requirements out of the box
- Assuming attestation is already validated when nothing custom was added
- Treating .NET 10 passkeys as a full WebAuthn platform when the app actually needs broader protocol coverage

If the product needs full WebAuthn behavior outside Identity, or stronger attestation handling, the built-in feature may be too narrow. That is a design constraint, not a bug, but it becomes a security problem if the team assumes otherwise.

## CORS

Primary checks:

- CORS should allow only the specific origins that actually need browser access.
- `AllowAnyOrigin` plus `AllowCredentials` is an insecure configuration and ASP.NET Core treats that combination as invalid.
- `UseCors` must run after `UseRouting` and before `UseAuthorization`.
- If the app serves static files that must be fetched cross-site by browser JavaScript, middleware order around `UseStaticFiles` also matters.

What I would flag as a regression:

- CORS broadened during the upgrade because someone wanted to "just get the frontend working"
- `AllowAnyOrigin` used anywhere credentials or cookies are involved
- Middleware order changed so unauthorized responses no longer carry the intended CORS headers
- Origin strings copied with trailing slashes, which ASP.NET Core explicitly warns can fail origin matching

CORS is not authentication. If the app is relying on CORS as if it were auth, that was already broken and the upgrade just made the corpse smell louder.

## Security regression assessment

With the inputs provided, I cannot confirm an existing regression in the current config. I can say these are the most plausible .NET 10 regressions to check first:

1. Cookie-authenticated API endpoints changed from redirect behavior to `401`/`403`, breaking existing clients or UI assumptions.
2. Cookie or cookie-policy changes broke OIDC correlation or nonce cookies by forcing the wrong `SameSite` behavior.
3. Passkeys were added under the assumption that they provide built-in second-factor support or work outside ASP.NET Core Identity.
4. CORS was widened too far, or middleware order was changed so auth failures no longer get the expected CORS headers.
5. OIDC token storage and cookie/session protection were changed without reviewing data protection, cookie lifetime, and revocation implications.

One useful .NET 10 follow-up is to enable and inspect the new ASP.NET Core Identity metrics for login attempts, sign-ins, sign-outs, and related auth behavior. That gives you actual evidence before anyone starts "fixing" auth by folklore.

## What I need for a real audit

To turn this into an actual config audit instead of a sharp lecture with citations, I need:

- `Program.cs` or `Startup.cs`
- `appsettings*.json` auth sections
- Cookie and OIDC option setup
- CORS policy registration and middleware order
- Identity and passkey configuration, if present
- Any deployment-specific data protection configuration

## Sources

- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/release-notes/aspnetcore-10.0?view=aspnetcore-10.0)
- [Enable Web Authentication API (WebAuthn) passkeys](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/passkeys/?view=aspnetcore-10.0)
- [Work with SameSite cookies in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/samesite?view=aspnetcore-9.0)
- [Enable Cross-Origin Requests (CORS) in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/security/cors?view=aspnetcore-9.0)
- [Secure an ASP.NET Core Blazor Web App with OpenID Connect (OIDC)](https://learn.microsoft.com/en-us/aspnet/core/blazor/security/blazor-web-app-with-oidc?view=aspnetcore-9.0)
