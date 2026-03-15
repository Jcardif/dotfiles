---
name: aspnet-core
description: ASP.NET Core skill for building, upgrading, debugging, securing, testing, deploying, reviewing, and modernizing ASP.NET Core apps and APIs. Use this whenever the task involves ASP.NET Core web apps, Web APIs, middleware, auth flows, hosting, OpenAPI, dependency injection, configuration, observability, performance, .NET 10 upgrades, modern C# usage, documentation review for public or reusable .NET APIs, or FastEndpoints projects. Also use it when a task changes ASP.NET Core code as part of issue implementation, even if the user does not explicitly ask for architecture or API guidance.
---

<!-- markdownlint-disable MD013 MD003 -->

# ASP.NET Core, Staff-Level Web Engineering

Use this skill as a staff-level ASP.NET Core engineer. Stay pragmatic, respect the existing architecture, and prefer current .NET 10 guidance unless the repo clearly needs compatibility-first decisions.

This skill is web-focused. It is not a generic ".NET everything" playbook.

Treat this skill as a contract, not a menu. Use all applicable guidance in the skill and any loaded references. Do not cherry-pick only the guidelines that are easiest to satisfy or the ones the user repeats back to you.

For new ASP.NET Core work on supported modern stacks, default to current C# guidance. Do not widen a surgical task into a language-version modernization unless the task explicitly includes modernization, the repo already trends that way, or the change materially depends on the newer feature.

Detailed material lives in `references/`. Load only what the task needs.

## Operating model

1. Inspect the repo before proposing changes or editing code.
2. Use live current docs for version-sensitive questions, then use the bundled references to structure the answer.
3. Preserve existing architecture unless it is actively harmful or the user asked for modernization.
4. Prefer simple, explicit solutions over ceremony, wrappers, or pattern cosplay.
5. Support FastEndpoints when present or explicitly requested, but do not push it as the default API style.
6. Load the relevant reference files for the areas the task actually touches. Do not claim compliance with this skill while ignoring the relevant reference material.
7. Before finishing, perform a full review of all applicable skill guidance, not just the most obvious implementation requirements.
8. Do not widen scope with drive-by framework, docs UI, language-version, or architectural migrations unless the task explicitly includes them or the current implementation is broken enough that staying put would be irresponsible.

## First-pass repo inspection

Check these before making architectural claims or implementation changes:

- App type and hosting model
- Target framework and SDK via `*.csproj`, `Directory.Build.*`, and `global.json`
- Nullable, analyzers, package management, and multi-targeting setup
- Existing HTTP style: minimal APIs, controllers, Razor Pages, Blazor, FastEndpoints
- Auth stack: Identity, cookies, bearer tokens, OIDC, external providers
- Observability stack: logging, OpenTelemetry, health checks, metrics, tracing
- Current tests and assertion style

Do not start implementation until this inspection is complete enough to avoid guessing about framework version, project shape, and test conventions.

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
- Use least exposure by default: `private` before `internal`, `internal` before `public`. Review every new or modified type and member before finishing, and reduce visibility to the narrowest valid level. Treat `public` as opt-in, not the default.
- Do not edit generated code such as `*.g.cs`, generated clients, or files marked auto-generated.
- Comments explain intent, constraints, or tradeoffs, not obvious control flow.
- Treat API documentation as part of the contract. Reusable public APIs should be well documented, and complex internal APIs should not stay undocumented just because they are internal.
- Audit every new or modified public type and public member before finishing. Add XML comments unless the member is a trivial DTO/property accessor or its full contract is already documented accurately through surrounding type-level documentation or `<inheritdoc/>`.
- For new or modified public methods, document the contract, important parameters, return behavior, likely exceptions, and non-obvious side effects. Do not decide a method is "obvious enough" without checking whether a caller would have to read the implementation to use it safely.
- Comments and docs should say something useful. Do not add boilerplate that merely restates the method or type name.
- Prefer secure defaults, structured logging, cancellation-aware async code, and explicit error handling.
- Prefer built-in platform features before adding another framework or indirection layer.
- Use current C# guidance when it fits the repo and task. Do not turn a local implementation task into a language-version upgrade unless that upgrade is explicitly in scope or materially required.
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

## Required pre-flight audit

Before editing code, explicitly inspect:

- Project type, hosting model, and endpoint style
- Target framework, SDK, and language version inputs
- Existing analyzers and formatting rules
- Existing test project shape and assertion style
- Existing API documentation and public surface conventions when the task touches reusable types
- Which reference files from this skill apply to the task, and load them before implementation when the task touches their area

If any of those are unclear, inspect more before implementing. Do not guess and do not skip this pass because the task "looks simple."

## Required pre-finish audit

Before marking work complete, review the diff against this checklist:

- Full-skill audit: review every relevant section of this skill and any loaded reference files, then apply all guidance that fits the task
- Applicability audit: for each major guideline area, decide whether it applies, does not apply, or was intentionally left unchanged, and do not silently skip categories
- Visibility audit: every new or modified type and member uses the narrowest valid accessibility
- Documentation audit: every new or modified public API has useful XML documentation, or a concrete reason it is intentionally omitted under the trivial-member exception
- Contract audit: exceptions, side effects, validation behavior, and non-obvious return behavior are documented where callers need them
- Source audit: version-sensitive decisions were checked against current official docs when needed
- Security audit: auth, secrets, CORS, CSRF, validation, exposure, and failure handling were reviewed when relevant to the change
- Diagnostics audit: logging, tracing, metrics, health checks, and error behavior stay consistent with repo conventions when relevant
- Async and reliability audit: cancellation, async flow, timeout/retry behavior, and external failure handling were reviewed when relevant
- Framework-fit audit: endpoint style, ASP.NET Core primitives, FastEndpoints usage, and modern C# choices fit the repo instead of fighting it
- Test audit: if observable behavior changed, add or update at least one targeted test unless impossible within repo constraints
- No-test audit: if no test was added for observable behavior, state why in the final response
- Architecture audit: changes stay inside the repo's existing ASP.NET Core and FastEndpoints patterns unless the user explicitly asked for modernization

Do not skip this audit just because the code builds or the issue acceptance criteria look satisfied.

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

When an implementation task touches one of these areas, load the relevant reference instead of pretending the top-level skill text is enough. If multiple areas apply, load the minimal set that covers the work and use all applicable guidance from them.

## Minimum load matrix

These are the minimum references to load for common task shapes:

- Architecture, repo-shape, endpoint-style, or modernization decisions: `references/overview-and-workflow.md`
- Endpoint, middleware, validation, error response, OpenAPI, routing, streaming, or HTTP behavior: `references/apis-and-http.md`
- Authentication, authorization, Identity, cookies, bearer tokens, OIDC, CORS, CSRF, secrets, passkeys, or secure defaults: `references/auth-and-security.md`
- Tests, assertions, diagnostics, logging, tracing, health checks, async correctness, or performance: `references/testing-performance-and-diagnostics.md`
- C# language features, XML comments, type design, DI safety, LINQ, or general code-shape decisions: `references/csharp.md`
- FastEndpoints repos or FastEndpoints-specific implementation: `references/fastendpoints.md`
- Framework upgrades, `LangVersion` changes, SDK changes, or migration planning: `references/upgrades-and-migrations.md`

If the task crosses categories, load each required reference before implementation. Do not invent a loophole where "I already know ASP.NET Core" replaces the relevant reference.

## Required final implementation report

When the task includes implementation, the final response must include:

- Which reference files were loaded and why
- Which major guideline areas were applicable
- Which verification steps were run
- Any intentional deviations from the skill or reference guidance
- Any areas that were not applicable, with a brief reason when that would not be obvious

Do not give a generic "done" summary that hides whether the skill was actually followed.

Use this exact structure when the task includes implementation:

```text
References used:
- <reference>: <why>

Applicability audit:
- Architecture/repo fit: applies | not applicable | intentionally unchanged - <reason>
- HTTP/API behavior: applies | not applicable | intentionally unchanged - <reason>
- Security/auth: applies | not applicable | intentionally unchanged - <reason>
- Testing/diagnostics/performance: applies | not applicable | intentionally unchanged - <reason>
- C# and API documentation: applies | not applicable | intentionally unchanged - <reason>
- FastEndpoints: applies | not applicable | intentionally unchanged - <reason>
- Upgrades/migrations: applies | not applicable | intentionally unchanged - <reason>

Verification:
- <check>

Intentional deviations:
- <deviation or "none">
```

## Required final report for non-implementation tasks

When the task is review, debugging, migration advice, or architecture guidance without code changes, the final response must still include:

- Which reference files were loaded and why
- Which major guideline areas were applicable
- What evidence, inspection, or verification informed the answer
- Any intentional scope limits or assumptions

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

When implementation work is involved, the final response should also call out which major guideline areas were relevant, what was verified, which reference files were used, and any tradeoffs intentionally left in place. Do not claim compliance with the skill unless you performed a full applicable-guidelines review.
