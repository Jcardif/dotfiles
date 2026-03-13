<!-- markdownlint-disable MD013 -->

# Auth and Security

Use this file when the task touches authentication, authorization, Identity, cookies, bearer tokens, OpenID Connect, CORS, CSRF, secrets, or secure defaults.

## Current source anchors

- [Auth overview](https://learn.microsoft.com/en-us/aspnet/core/security/)
- [ASP.NET Core Identity](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/identity)
- [Authorization](https://learn.microsoft.com/en-us/aspnet/core/security/authorization/introduction)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)

Notable .NET 10 signal:

- ASP.NET Core Identity now includes passkey support based on WebAuthn and FIDO2
- Authentication and authorization metrics are now built in
- Identity observability improved with new metrics
- Built-in passkeys are intentionally scoped and have real limitations

## Default posture

- Secure by default
- Least privilege by default
- Prefer built-in handlers and platform features before custom auth plumbing
- Make configuration explicit and environment-driven
- Never hardcode secrets

## Authentication choices

### Cookies and Identity

Use when:

- The app is server-rendered or uses interactive browser flows
- The repo already uses ASP.NET Core Identity
- You need established account management and sign-in flows

Watch for:

- Misconfigured cookie policies
- Missing antiforgery protections where relevant
- Weak password-reset or email-confirmation flows

### Bearer tokens and APIs

Use when:

- The app is API-first
- Clients are SPAs, native apps, CLIs, or service-to-service callers

Watch for:

- Token validation settings copied from a blog post and never revisited
- Missing audience, issuer, lifetime, and clock-skew scrutiny
- Custom token parsing middleware when built-in handlers already exist

### OpenID Connect

Use when:

- The app delegates identity to an external provider
- Interactive browser sign-in is required

Watch for:

- Callback and logout URI mismatches
- Cookie plus OIDC handler ordering issues
- Claims mapping surprises

### Passkeys

Built-in .NET 10 passkeys are a good default when:

- The app already uses ASP.NET Core Identity
- The goal is passwordless primary sign-in
- The built-in Identity passkey flow covers the product requirements

Important limitations from the current Microsoft docs:

- Passkeys are treated as a primary authentication factor, not built-in 2FA
- The built-in support is tied to ASP.NET Core Identity, not a general-purpose WebAuthn stack
- Advanced capabilities such as fuller attestation workflows may require a third-party library

When those limits become a real problem, strongly consider [`passwordless-lib/fido2-net-lib`](https://github.com/passwordless-lib/fido2-net-lib).

Use that path when:

- The app is not built around ASP.NET Core Identity
- The project needs broader WebAuthn or FIDO2 support
- Attestation handling matters
- The built-in .NET 10 passkey feature set is too narrow for the product

If you recommend `fido2-net-lib`, call out that it is security-critical infrastructure and should be reviewed and updated accordingly.

## Authorization

Prefer policy-based authorization over ad hoc role string checks scattered through handlers.

- Centralize policies
- Keep resource-based authorization near the resource boundary
- Use endpoint metadata consistently
- Review anonymous access carefully, especially during migrations

## Data protection and secrets

- Inspect how data protection keys are stored before touching cookies or Identity
- Use secret stores or environment-backed configuration
- Do not assume local development storage works in production topologies
- Be cautious when changing key persistence in distributed deployments

## Web security basics that still break apps

- CORS is not authentication
- CSRF matters for cookie-based browser flows
- HTTPS redirection and forwarded headers must match the hosting topology
- SameSite and cookie settings can break legitimate auth flows if changed blindly
- JSON Patch has inherent security risk and needs careful surface control

## Observability for auth

In .NET 10, auth and Identity metrics are stronger than before. Use them.

Check:

- Authenticated request duration
- Challenge and forbid counts
- Sign-in and sign-out counts
- Authorization-required request counts
- Identity-specific metrics for sign-in behavior and flows

If auth is failing in production, get telemetry before rewriting handlers.

## Common failure modes

- `UseAuthentication()` or `UseAuthorization()` in the wrong place
- Scheme names mismatched between registration and usage
- Cookie and OIDC handlers registered but callback pipeline broken
- Identity added, but the underlying stores, tokens, or key management are half-configured
- CORS policy too broad or applied in the wrong place
- Secrets pulled from source control, because apparently suffering is a deployment strategy now
