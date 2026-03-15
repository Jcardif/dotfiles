<!-- markdownlint-disable MD013 -->

# APIs and HTTP

Use this file for endpoint design, routing, middleware, validation, problem details, OpenAPI, streaming, caching, and HTTP pipeline behavior.

## Scope

This file governs:

- endpoint style and route design
- middleware order and HTTP pipeline behavior
- validation and error response consistency
- OpenAPI accuracy and API docs behavior
- streaming, SSE, and long-lived HTTP responses

## Current source anchors

- [ASP.NET Core docs](https://learn.microsoft.com/en-us/aspnet/core/)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)
- [Minimal APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis)

Key .NET 10 items worth remembering:

- minimal API validation integrates with `IProblemDetailsService`
- `TypedResults.ServerSentEvents(...)` supports SSE in both minimal APIs and controller-based apps
- `Microsoft.AspNetCore.OpenApi` support is stronger in .NET 10 templates and services
- `IOpenApiDocumentProvider` is available from DI in .NET 10
- the `System.Text.Json`-based JSON Patch implementation is faster, but JSON Patch still carries inherent security risk

Apply .NET 10-specific guidance only when the inspected target framework and current docs confirm the repo is on a compatible version.

## Required pre-flight inspection

Before implementation or HTTP advice, inspect:

- endpoint style already used by the repo
- `Program.cs`, `Startup.cs`, route registration, and middleware order
- validation and error response conventions
- OpenAPI generation path and docs UI already in use
- auth, CORS, caching, rate limiting, and streaming behavior when relevant

## API style choices

### Minimal APIs

Prefer minimal APIs when:

- the app is API-first and already uses top-level route mapping
- the endpoint surface is straightforward
- endpoint filters and grouped route configuration are enough
- low ceremony and clear local composition fit the repo

Watch for:

- validation and error responses drifting into inconsistent custom code
- route modules becoming a dumping ground
- business logic getting stuffed into delegate bodies

### Controllers

Prefer controllers when:

- the repo already uses controllers
- action filters and controller conventions are already part of the app shape
- the team wants class-based discoverability and separation
- the API has many related endpoints where controller organization is clearer than route groups

Do not migrate to minimal APIs just because they are newer.

## Pipeline rules

Be explicit about middleware order. Common safe baseline:

1. Exception handling and diagnostics
2. HTTPS, HSTS, forwarded headers when applicable
3. Static files if used
4. Routing
5. Authentication
6. Authorization
7. Rate limiting, output caching, antiforgery, or other policy middleware as needed
8. Endpoint execution

Order mistakes create fake bugs. If auth or CORS looks broken, inspect middleware order before inventing a theory.

## Validation and error responses

Prefer one coherent validation story per app.

- use built-in validation support where it fits
- return consistent problem details payloads
- keep transport validation, domain validation, and business rules distinct
- for minimal APIs in .NET 10, align validation failures with `IProblemDetailsService`
- do not scatter ad hoc `BadRequest("nope")` responses everywhere

Use JSON Patch only when partial-document updates are truly needed, and document the risk. Its security concerns are part of the standard, not a bug you can wish away.

## OpenAPI

Prefer OpenAPI that matches real behavior:

- document auth requirements, status codes, and error payloads
- keep schemas honest
- avoid stale annotations that describe a fantasy API
- if the app uses document providers or generation hooks, inspect them before changing endpoint metadata
- prefer Scalar for new docs UI decisions or when the task explicitly includes docs UI modernization
- if the repo already uses another docs UI, preserve it unless the current setup is broken or the task explicitly includes replacing it

## Streaming and long-lived responses

Use SSE for simple one-way event streams where WebSockets are unnecessary. In .NET 10, `TypedResults.ServerSentEvents(...)` is a first-class option for both minimal APIs and controllers.

When dealing with streams:

- propagate `CancellationToken`
- flush responsibly
- keep payloads incremental
- make reconnection behavior a client concern when using SSE

## Built-in features worth preferring

- route groups for shared tags, policies, and prefixes
- `TypedResults` for clearer response shapes
- output caching and rate limiting when the traffic model justifies them
- `ProblemDetails` infrastructure instead of hand-built error envelopes
- built-in OpenAPI support before reaching for extra ceremony
- Scalar as the preferred UI only for new setups or explicit docs UI changes

## Smells

- endpoint delegates doing orchestration, mapping, validation, and persistence all at once
- middleware with hidden side effects or unclear order dependencies
- multiple error response formats in the same API
- OpenAPI docs that promise responses the code never emits
- controllers and minimal APIs duplicated for the same resource surface

## FastEndpoints boundary

If the repo uses FastEndpoints or the task explicitly targets it, load [FastEndpoints](fastendpoints.md). Do not mix its programming model casually into regular minimal API guidance.

## Required HTTP audit

Before finishing, review the task against this checklist:

- endpoint-style audit: the chosen HTTP style matches the repo unless modernization was explicitly requested
- pipeline audit: middleware order was inspected when relevant
- validation audit: validation behavior is coherent and error payloads stay consistent
- problem-details audit: error responses do not drift into ad hoc envelopes without a repo-level reason
- OpenAPI audit: docs match real request, auth, status-code, and error behavior
- docs UI audit: no docs UI migration was introduced unless the task explicitly included it or the existing setup is broken
- streaming audit: SSE or streaming work propagates cancellation and uses incremental payload behavior where relevant
- built-in features audit: built-in ASP.NET Core features were preferred over custom plumbing where appropriate

## Required final reporting

When this file is loaded, the final response should state:

- endpoint style used or preserved
- whether middleware or HTTP pipeline behavior changed
- how validation and error response consistency were verified
- how OpenAPI or docs behavior was verified, if relevant
- whether streaming, caching, rate limiting, or CORS behavior was reviewed

## Scope control

Do not:

- migrate controllers to minimal APIs, or vice versa, unless the task explicitly includes that change
- switch docs UI tooling as a side quest
- introduce custom error envelopes when repo conventions or built-in `ProblemDetails` already fit
- add HTTP abstractions just to make the code look "architected"
