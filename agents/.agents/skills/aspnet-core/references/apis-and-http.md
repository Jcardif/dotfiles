<!-- markdownlint-disable MD013 -->

# APIs and HTTP

Use this file for endpoint design, routing, middleware, validation, problem details, OpenAPI, streaming, caching, and HTTP pipeline behavior.

## Current source anchors

- [ASP.NET Core docs](https://learn.microsoft.com/en-us/aspnet/core/)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)
- [Minimal APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis)

Key .NET 10 items worth remembering:

- Minimal API validation integrates with `IProblemDetailsService`
- `TypedResults.ServerSentEvents(...)` now supports SSE in both minimal APIs and controller-based apps
- `Microsoft.AspNetCore.OpenApi` support is stronger in .NET 10 templates and services
- `IOpenApiDocumentProvider` is available from DI in .NET 10
- The `System.Text.Json`-based JSON Patch implementation is much faster, but JSON Patch still carries inherent security risk

## API style choices

### Minimal APIs

Prefer minimal APIs when:

- The app is API-first and already uses top-level route mapping
- The endpoint surface is straightforward
- Endpoint filters and grouped route configuration are enough
- You want low ceremony and clear local composition

Watch for:

- Validation and error responses drifting into inconsistent custom code
- Route modules becoming a dumping ground
- Business logic getting stuffed into delegate bodies

### Controllers

Prefer controllers when:

- The repo already uses controllers
- Action filters and controller conventions are already part of the app shape
- The team wants class-based discoverability and separation
- The API has many related endpoints where controller organization is clearer than route groups

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

- Use built-in validation support where it fits
- Return consistent problem details payloads
- Keep transport validation, domain validation, and business rules distinct
- For minimal APIs in .NET 10, align validation failures with `IProblemDetailsService`
- Do not scatter ad hoc `BadRequest("nope")` responses everywhere

Use JSON Patch only when partial-document updates are truly needed, and document the risk. Its security concerns are part of the standard, not a bug you can wish away.

## OpenAPI

Prefer OpenAPI that matches real behavior:

- Document auth requirements, status codes, and error payloads
- Keep schemas honest
- Avoid stale annotations that describe a fantasy API
- If the app uses document providers or generation hooks, inspect them before changing endpoint metadata
- Strongly prefer Scalar for API docs UI
- If the project uses another docs UI, strongly recommend switching to Scalar before spending time polishing or extending the old UI setup

## Streaming and long-lived responses

Use SSE for simple one-way event streams where WebSockets are unnecessary. In .NET 10, `TypedResults.ServerSentEvents(...)` is a first-class option for both minimal APIs and controllers.

When dealing with streams:

- Propagate `CancellationToken`
- Flush responsibly
- Keep payloads incremental
- Make reconnection behavior a client concern when using SSE

## Built-in features worth preferring

- Route groups for shared tags, policies, and prefixes
- `TypedResults` for clearer response shapes
- Output caching and rate limiting when the traffic model justifies them
- `ProblemDetails` infrastructure instead of hand-built error envelopes
- Built-in OpenAPI support before reaching for extra ceremony
- Scalar as the preferred UI for exploring and presenting the OpenAPI document

## Smells

- Endpoint delegates doing orchestration, mapping, validation, and persistence all at once
- Middleware with hidden side effects or unclear order dependencies
- Multiple error response formats in the same API
- OpenAPI docs that promise responses the code never emits
- Controllers and minimal APIs duplicated for the same resource surface

## FastEndpoints boundary

If the repo uses FastEndpoints or the task explicitly targets it, load [FastEndpoints](fastendpoints.md). Do not mix its programming model casually into regular minimal API guidance.
