<!-- markdownlint-disable MD013 -->

# Testing, Performance, and Diagnostics

Use this file for test strategy, assertion style, mocking, async correctness, observability, performance, and production debugging.

## Current source anchors

- [Testing ASP.NET Core apps](https://learn.microsoft.com/en-us/aspnet/core/test/)
- [ASP.NET Core performance](https://learn.microsoft.com/en-us/aspnet/core/performance/)
- [ASP.NET Core logging and diagnostics](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/logging/)
- [.NET 10 runtime improvements](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-10/runtime)

## Testing defaults

- Match the repo's existing test framework unless the user asked to change it
- Support xUnit, NUnit, or MSTest
- Prefer `FluentAssertions` or `AwesomeAssertions` when compatible with the repo
- Use clear behavior-focused test names and assert specific outcomes
- Test through public behavior instead of punching holes in visibility

## Mocking rules

- Avoid mocks when a simple real collaborator or focused test double is enough
- Mock true external dependencies only
- Do not mock code that is implemented inside the solution under test
- Prefer verifying outputs and behavior over verifying implementation chatter

If a mock is unavoidable, keep it honest. A fake dependency that returns impossible data teaches the test suite to lie.

## Integration testing

Use integration tests for HTTP behavior, auth flows, middleware, filters, serialization, and endpoint wiring.

Good candidates:

- Route mapping and status codes
- Validation responses
- Auth and authorization behavior
- OpenAPI generation checks when the contract matters
- DI and configuration wiring

## Async correctness

For web code:

- Use the `Async` suffix for async methods unless framework conventions define the shape.
- Return `Task<T>` or `Task` by default. Use `ValueTask` only when measurement or an established API surface justifies it.
- Keep async end-to-end
- Propagate `CancellationToken`
- Avoid sync-over-async
- Do not drop returned tasks unless a deliberate background-processing mechanism owns the work
- Avoid fire-and-forget unless the work is explicitly owned by a background service
- Use `ConfigureAwait(false)` in reusable library code when appropriate, not blindly in app code
- Prefer `Task.WhenAll()` for independent parallel work and `Task.WhenAny()` for first-completion or timeout patterns
- Use `Task.Run` only for deliberate short CPU-bound work, not as a bandage for normal request-path async code
- Avoid pointless `async` / `await` wrappers when a method only passes through an existing task
- Prefer TAP-style async APIs for reusable public async surfaces
- Use async streams when the data shape is genuinely sequential or streaming

## Diagnostics baseline

Prefer structured logs and traces over heroic guesswork.

Inspect:

- `ILogger` usage and scopes
- OpenTelemetry registration
- Metrics, tracing, and health checks
- Correlation IDs and request context
- Built-in auth and server metrics in .NET 10

When debugging production issues, start with telemetry, not vibes.

## Performance guidance

- Keep code simple first, then optimize hot paths that you can measure
- Stream large payloads where appropriate
- Avoid unnecessary allocations in serialization and buffering-heavy paths
- Watch database access, N+1 queries, and chatty downstream calls before micro-optimizing controller code
- Reuse built-in ASP.NET Core features before building custom caching or concurrency machinery

.NET 10 matters here:

- Runtime improvements help JIT, stack allocation, and code generation
- ASP.NET Core memory pools now evict unused blocks more aggressively
- The `System.Text.Json` JSON Patch implementation is substantially faster than the older Newtonsoft-based version

Do not turn those into excuses to stop measuring the real bottleneck.

## Production-debugging workflow

1. Reproduce the symptom as narrowly as possible
2. Confirm logs, traces, metrics, and health state
3. Check middleware order, auth configuration, and DI lifetimes
4. Verify downstream dependencies and timeouts
5. Only then start changing code

## Common smells

- Unit tests that mostly configure mocks and assert the same configured values
- Broad `catch (Exception)` blocks that hide the real problem
- Background work kicked off from request handlers with no lifecycle ownership
- Logging without request context
- Performance “fixes” based on folklore instead of measurement

## Test quality

- Tests should isolate real behavior, stay fast, and avoid real I/O unless the test is explicitly integration-level
- Prefer tests that give you confidence to merge risky changes, not tests that mostly restate mock setup
- Keep unit tests focused on business behavior and integration tests focused on HTTP, wiring, auth, and persistence boundaries
