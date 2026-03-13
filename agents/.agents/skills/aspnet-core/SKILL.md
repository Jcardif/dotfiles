---
name: aspnet-core
description: ASP.NET Core skill for building, upgrading, debugging, securing, testing, deploying, reviewing, and modernizing ASP.NET Core apps and APIs. Use this whenever the task involves ASP.NET Core web apps, Web APIs, middleware, auth flows, hosting, OpenAPI, dependency injection, configuration, observability, performance, .NET 10 upgrades, modern C# usage in server-side code, XML comments, API documentation, documentation review for public or reusable .NET APIs, or FastEndpoints projects.
---

<!-- markdownlint-disable MD013 MD003 -->

# ASP.NET Core, Staff-Level Web Engineering

Use this skill as a staff-level ASP.NET Core engineer. Stay pragmatic, respect the existing architecture, and prefer current .NET 10 guidance unless the repo clearly needs compatibility-first decisions.

This skill is web-focused. It is not a generic ".NET everything" playbook.

Default to C# 14 for active ASP.NET Core development on supported stacks. If a project is on an older language version without a hard compatibility reason, strongly recommend moving it to C# 14 instead of preserving the older baseline out of inertia.

Detailed material lives in `references/`. Load only what the task needs.

## Operating model

1. Inspect the repo before proposing changes.
2. Use live current docs for version-sensitive questions, then use the bundled references to structure the answer.
3. Preserve existing architecture unless it is actively harmful or the user asked for modernization.
4. Prefer simple, explicit solutions over ceremony, wrappers, or pattern cosplay.
5. Support FastEndpoints when present or explicitly requested, but do not push it as the default API style.

## First-pass repo inspection

Check these before making architectural claims:

- App type and hosting model
- Target framework and SDK via `*.csproj`, `Directory.Build.*`, and `global.json`
- Nullable, analyzers, package management, and multi-targeting setup
- Existing HTTP style: minimal APIs, controllers, Razor Pages, Blazor, FastEndpoints
- Auth stack: Identity, cookies, bearer tokens, OIDC, external providers
- Observability stack: logging, OpenTelemetry, health checks, metrics, tracing
- Current tests and assertion style

## Source priority

For version-sensitive topics such as .NET 10, C# 12 through C# 14, templates, APIs, and breaking changes:

1. Prefer current primary sources:
   - [Microsoft Learn](https://learn.microsoft.com/)
   - [.NET Blog](https://devblogs.microsoft.com/dotnet/)
   - Official `dotnet` repos
   - [FastEndpoints docs](https://fast-endpoints.com/) and repo when FastEndpoints is involved
2. Use bundled references to decide what matters and how to apply it.
3. If the repo already chose a different pattern, adapt to the repo unless the user asked to modernize it.

If tooling allows live docs lookup, use it. Do not bluff on unstable details.

## Engineering guardrails

- Follow repo conventions first, then normal ASP.NET Core and C# conventions.
- Prefer clarity, boring code, and explicit behavior over clever syntax or fashionable patterns.
- Avoid speculative abstractions, unnecessary interfaces, wrapper-on-wrapper designs, and DRY theater.
- Use least exposure by default: `private` before `internal`, `internal` before `public`.
- Do not edit generated code such as `*.g.cs`, generated clients, or files marked auto-generated.
- Comments explain intent, constraints, or tradeoffs, not obvious control flow.
- Treat API documentation as part of the contract. Reusable public APIs should be well documented, and complex internal APIs should not stay undocumented just because they are internal.
- Document public methods and other reusable APIs with XML comments when the contract, parameters, return behavior, exceptions, or usage are not obvious from the signature.
- Comments and docs should say something useful. Do not add boilerplate that merely restates the method or type name.
- Prefer secure defaults, structured logging, cancellation-aware async code, and explicit error handling.
- Prefer built-in platform features before adding another framework or indirection layer.
- Default to C# 14 on supported projects and strongly recommend upgrading if the repo is lagging without a real constraint.
- Use modern C# when it simplifies the code. Do not keep older syntax just because the team got used to it.
- Prefer primary constructors for straightforward DI-heavy types when the repo uses modern C# and the result stays obvious.
- Prefer records for DTOs and value-like transport types when mutability is not required.
- Prefer `TypedResults` over untyped `Results` in minimal APIs.
- Keep endpoint and application code straightforward. Reserve unusual language tricks and low-level tuning for infrastructure or measured hot paths.
- Treat testability as an outcome of sane design, not an excuse to inject abstraction everywhere.
- Prefer `FluentAssertions` or `AwesomeAssertions` when compatible with the repo.
- Avoid mocks unless the dependency is truly external. Do not mock code implemented inside the solution under test.
- Measure before optimizing. Performance advice without a hotspot is just fan fiction.
- Keep async all the way through request paths. Do not block on async work.
- Use LINQ for clarity, not cleverness. Avoid hidden multiple enumeration and query-shape surprises.
- Treat SOLID as guidance, not dogma. Use CQRS, Unit of Work, and classic patterns only when the problem actually warrants them.

## Reference map

| Reference | Load when |
| --- | --- |
| [Overview and Workflow](references/overview-and-workflow.md) | You need overall decision rules, repo inspection steps, or architecture triage |
| [APIs and HTTP](references/apis-and-http.md) | You are building or reviewing endpoints, middleware, validation, OpenAPI, SSE, rate limiting, or HTTP behavior |
| [Auth and Security](references/auth-and-security.md) | The task touches authentication, authorization, cookies, bearer tokens, OIDC, Identity, CORS, CSRF, or secrets |
| [Upgrades and Migrations](references/upgrades-and-migrations.md) | The task involves upgrading .NET or ASP.NET Core, modernizing older code, or evaluating compatibility and breaking changes |
| [Testing, Performance, and Diagnostics](references/testing-performance-and-diagnostics.md) | The task involves tests, assertions, mocking, async correctness, profiling, logging, tracing, metrics, or hot paths |
| [C#](references/csharp.md) | The task involves C# in an ASP.NET Core or .NET codebase, especially for feature adoption, unfamiliar syntax, compatibility, type design, XML comments, API documentation, LINQ, or common anti-patterns |
| [FastEndpoints](references/fastendpoints.md) | The repo already uses FastEndpoints, or the task explicitly targets FastEndpoints |

## Default guidance

### New work

- Prefer current .NET 10 patterns.
- For APIs, choose minimal APIs or controllers based on the repo shape, validation needs, filters, and discoverability.
- Use `ProblemDetails`-style error responses and keep validation behavior consistent.
- Favor built-in ASP.NET Core features before adding extra frameworks.

### Existing code

- Match the current architecture unless the user asked for a redesign.
- Modernize incrementally.
- Avoid large rewrites when a targeted fix or staged migration is safer.

### FastEndpoints

- If the repo uses FastEndpoints, stay inside that programming model.
- If the task explicitly targets FastEndpoints, load the FastEndpoints reference and treat it as a valid first-class choice.
- Otherwise, do not replace standard ASP.NET Core endpoint styles with FastEndpoints just because it exists.

## What good answers look like

Tailor the output to the task:

- Implementation plan with concrete framework choices
- Migration plan with risk areas and compatibility notes
- Debugging summary with likely failure points and verification steps
- Security review with concrete findings and safer defaults
- Performance review with measured or likely hotspots
- Testing plan with framework fit, assertion style, and minimal mocking

Prefer direct recommendations. Explain tradeoffs when they are real, not decorative.
