<!-- markdownlint-disable MD013 -->

# Auth and Security

Use this file when the task touches authentication, authorization, Identity, cookies, bearer tokens, OpenID Connect, CORS, CSRF, secrets, or secure defaults.

## Scope

This file governs:

- authentication and authorization choices
- cookie, bearer-token, OIDC, and Identity behavior
- secrets, data protection, and secure configuration
- CORS, CSRF, forwarded headers, and auth-related hosting concerns
- auth-related telemetry and third-party security dependencies

## Current source anchors

- [Auth overview](https://learn.microsoft.com/en-us/aspnet/core/security/)
- [ASP.NET Core Identity](https://learn.microsoft.com/en-us/aspnet/core/security/authentication/identity)
- [Authorization](https://learn.microsoft.com/en-us/aspnet/core/security/authorization/introduction)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)

Notable .NET 10 signal:

- ASP.NET Core Identity includes passkey support based on WebAuthn and FIDO2
- authentication and authorization metrics are built in
- Identity observability improved with new metrics
- built-in passkeys are intentionally scoped and have real limitations

## Default posture

- secure by default
- least privilege by default
- prefer built-in handlers and platform features before custom auth plumbing
- make configuration explicit and environment-driven
- never hardcode secrets

## Required pre-flight inspection

Before implementation or recommendations, inspect:

- registered authentication schemes and defaults
- authorization policies and anonymous access usage
- cookie, bearer-token, OIDC, or Identity configuration relevant to the task
- callback URLs, logout paths, and forwarded-header behavior when relevant
- data protection key storage and secret sources
- CORS, CSRF, SameSite, and HTTPS/forwarded-header behavior for browser-facing flows
- existing auth-related telemetry, metrics, and logs when diagnosing problems

## Authentication choices

### Cookies and Identity

Use when:

- the app is server-rendered or uses interactive browser flows
- the repo already uses ASP.NET Core Identity
- established account management and sign-in flows are required

Watch for:

- misconfigured cookie policies
- missing antiforgery protections where relevant
- weak password-reset or email-confirmation flows

### Bearer tokens and APIs

Use when:

- the app is API-first
- clients are SPAs, native apps, CLIs, or service-to-service callers

Watch for:

- token validation settings copied from a blog post and never revisited
- missing audience, issuer, lifetime, and clock-skew scrutiny
- custom token parsing middleware when built-in handlers already exist

### OpenID Connect

Use when:

- the app delegates identity to an external provider
- interactive browser sign-in is required

Watch for:

- callback and logout URI mismatches
- cookie plus OIDC handler ordering issues
- claims mapping surprises

### Passkeys

Built-in .NET 10 passkeys are a good default when:

- the app already uses ASP.NET Core Identity
- the goal is passwordless primary sign-in
- the built-in Identity passkey flow covers the product requirements

Important limitations from the current Microsoft docs:

- passkeys are treated as a primary authentication factor, not built-in 2FA
- the built-in support is tied to ASP.NET Core Identity, not a general-purpose WebAuthn stack
- advanced capabilities such as fuller attestation workflows may require a third-party library

When those limits become a real problem, strongly consider [`passwordless-lib/fido2-net-lib`](https://github.com/passwordless-lib/fido2-net-lib).

Use that path when:

- the app is not built around ASP.NET Core Identity
- the project needs broader WebAuthn or FIDO2 support
- attestation handling matters
- the built-in .NET 10 passkey feature set is too narrow for the product

Treat any third-party auth or cryptography dependency as security-critical infrastructure. Do not recommend one casually, and do not widen scope to swap auth stacks unless the task requires it.

## Authorization

Prefer policy-based authorization over ad hoc role string checks scattered through handlers.

- centralize policies
- keep resource-based authorization near the resource boundary
- use endpoint metadata consistently
- review anonymous access carefully, especially during migrations

## Data protection and secrets

- inspect how data protection keys are stored before touching cookies or Identity
- use secret stores or environment-backed configuration
- do not assume local development storage works in production topologies
- be cautious when changing key persistence in distributed deployments

## Web security basics that still break apps

- CORS is not authentication
- CSRF matters for cookie-based browser flows
- HTTPS redirection and forwarded headers must match the hosting topology
- SameSite and cookie settings can break legitimate auth flows if changed blindly
- JSON Patch has inherent security risk and needs careful surface control

## Observability for auth

In .NET 10, auth and Identity metrics are stronger than before. Use them when relevant.

Check:

- authenticated request duration
- challenge and forbid counts
- sign-in and sign-out counts
- authorization-required request counts
- Identity-specific metrics for sign-in behavior and flows

If auth is failing in production, get telemetry before rewriting handlers.

## Common failure modes

- `UseAuthentication()` or `UseAuthorization()` in the wrong place
- scheme names mismatched between registration and usage
- cookie and OIDC handlers registered but callback pipeline broken
- Identity added, but the underlying stores, tokens, or key management are half-configured
- CORS policy too broad or applied in the wrong place
- secrets pulled from source control, because apparently suffering is a deployment strategy now

## Required security audit

Before finishing, review the task against this checklist:

- scheme audit: authentication schemes, defaults, and policy usage were inspected when relevant
- handler audit: built-in handlers were preferred over custom auth plumbing unless the task required otherwise
- secrets audit: secrets stay environment-driven and are not introduced into source control
- data-protection audit: key storage and cookie or Identity implications were reviewed when relevant
- browser-flow audit: CORS, CSRF, SameSite, callback URLs, logout paths, HTTPS, and forwarded headers were reviewed when relevant
- token audit: issuer, audience, lifetime, clock skew, and validation settings were reviewed for bearer-token work
- telemetry audit: auth-related logs, metrics, or traces were reviewed or preserved when relevant
- third-party dependency audit: any third-party security package recommendation is justified and called out as security-critical

## Required final reporting

When this file is loaded, the final response should state:

- which auth/security surfaces were touched
- which auth/security checks were relevant
- whether secrets, key storage, cookies, token validation, browser-flow protections, or callback behavior were reviewed
- any third-party security dependency introduced or recommended
- any intentionally unchanged security behavior

## Scope control

Do not:

- replace the repo's auth stack as a side quest
- widen a bug fix into an Identity or OIDC redesign
- add third-party auth/security libraries without a concrete requirement
- treat CORS as authentication or skip CSRF review for cookie-based browser flows
