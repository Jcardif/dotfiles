<!-- markdownlint-disable MD013 -->

# Testing, Performance, and Diagnostics

Use this file for test strategy, assertion style, mocking, async correctness, observability, performance, and production debugging.

## Scope

This file governs:

- test level and verification strategy
- mocking discipline and async correctness
- diagnostics, logging, tracing, metrics, and health behavior
- performance guidance and performance-claim discipline

## Current source anchors

- [Testing ASP.NET Core apps](https://learn.microsoft.com/en-us/aspnet/core/test/)
- [ASP.NET Core performance](https://learn.microsoft.com/en-us/aspnet/core/performance/)
- [ASP.NET Core logging and diagnostics](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/logging/)
- [.NET 10 runtime improvements](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-10/runtime)

## Required pre-flight inspection

Before implementation or recommendations, inspect:

- the repo's test framework and assertion style
- existing test coverage around the changed behavior
- logging, tracing, metrics, and health-check conventions when relevant
- async and background-work patterns touched by the task
- whether any performance claim is based on measurement, profiling, or observed telemetry

## Testing defaults

- match the repo's existing test framework unless the user asked to change it
- support xUnit, NUnit, or MSTest
- prefer `FluentAssertions` or `AwesomeAssertions` when compatible with the repo
- use clear behavior-focused test names and assert specific outcomes
- test through public behavior instead of punching holes in visibility

## Mocking rules

- avoid mocks when a simple real collaborator or focused test double is enough
- mock true external dependencies only
- do not mock code that is implemented inside the solution under test
- prefer verifying outputs and behavior over verifying implementation chatter

If a mock is unavoidable, keep it honest. A fake dependency that returns impossible data teaches the test suite to lie.

## Integration testing

Use integration tests for HTTP behavior, auth flows, middleware, filters, serialization, and endpoint wiring.

Good candidates:

- route mapping and status codes
- validation responses
- auth and authorization behavior
- OpenAPI generation checks when the contract matters
- DI and configuration wiring

## Async correctness

For web code:

- use the `Async` suffix for async methods unless framework conventions define the shape
- return `Task<T>` or `Task` by default, use `ValueTask` only when measurement or an established API surface justifies it
- keep async end-to-end
- propagate `CancellationToken`
- avoid sync-over-async
- do not drop returned tasks unless a deliberate background-processing mechanism owns the work
- avoid fire-and-forget unless the work is explicitly owned by a background service
- use `ConfigureAwait(false)` in reusable library code when appropriate, not blindly in app code
- prefer `Task.WhenAll()` for independent parallel work and `Task.WhenAny()` for first-completion or timeout patterns
- use `Task.Run` only for deliberate short CPU-bound work, not as a bandage for normal request-path async code
- avoid pointless `async` / `await` wrappers when a method only passes through an existing task
- prefer TAP-style async APIs for reusable public async surfaces
- use async streams when the data shape is genuinely sequential or streaming

## Diagnostics baseline

Prefer structured logs and traces over guesswork.

Inspect:

- `ILogger` usage and scopes
- OpenTelemetry registration
- metrics, tracing, and health checks
- correlation IDs and request context
- built-in auth and server metrics in .NET 10 when relevant

When debugging production issues, start with telemetry, not vibes.

## Performance guidance

- keep code simple first, then optimize hot paths that you can measure
- stream large payloads where appropriate
- avoid unnecessary allocations in serialization and buffering-heavy paths
- watch database access, N+1 queries, and chatty downstream calls before micro-optimizing controller code
- reuse built-in ASP.NET Core features before building custom caching or concurrency machinery

.NET 10 matters here:

- runtime improvements help JIT, stack allocation, and code generation
- ASP.NET Core memory pools now evict unused blocks more aggressively
- the `System.Text.Json` JSON Patch implementation is substantially faster than the older Newtonsoft-based version

Do not turn those into excuses to stop measuring the real bottleneck.

## Production-debugging workflow

1. Reproduce the symptom as narrowly as possible
2. Confirm logs, traces, metrics, and health state
3. Check middleware order, auth configuration, and DI lifetimes
4. Verify downstream dependencies and timeouts
5. Only then start changing code

## Common smells

- unit tests that mostly configure mocks and assert the same configured values
- broad `catch (Exception)` blocks that hide the real problem
- background work kicked off from request handlers with no lifecycle ownership
- logging without request context
- performance "fixes" based on folklore instead of measurement

## Test quality

- tests should isolate real behavior, stay fast, and avoid real I/O unless the test is explicitly integration-level
- prefer tests that give confidence to merge risky changes, not tests that mostly restate mock setup
- keep unit tests focused on business behavior and integration tests focused on HTTP, wiring, auth, and persistence boundaries

## Required testing and diagnostics audit

Before finishing, review the task against this checklist:

- test decision audit: choose `unit`, `integration`, `both`, or `none`, and be able to justify the choice
- coverage audit: observable behavior changes add or update targeted tests unless impossible within repo constraints
- no-test audit: if no test was added, explain why
- mocking audit: mocks are limited to true external dependencies and are not used to fake internal solution code
- async audit: cancellation, async flow, background ownership, and sync-over-async risks were reviewed when relevant
- diagnostics audit: logging, tracing, metrics, health checks, and request context remain consistent with repo conventions when relevant
- performance audit: performance claims are tied to evidence, not folklore

## Required final reporting

When this file is loaded, the final response should state:

- chosen test level: `unit`, `integration`, `both`, or `none`
- what verification actually ran
- why no test was added, if applicable
- whether diagnostics or health behavior changed or was reviewed
- whether any performance advice or change was evidence-based

## Scope control

Do not:

- skip tests for observable behavior and pretend the build is enough
- use performance language without evidence
- add mocks for internal solution code just to make tests easier
- kick off background work from request paths without clear ownership
