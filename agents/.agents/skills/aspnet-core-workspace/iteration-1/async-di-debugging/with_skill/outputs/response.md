# Async, DI, and Background Work Review

<!-- markdownlint-configure-file { "MD013": false } -->

No application code was provided, so this is not a repo-specific bug report. It is a failure-mode review of the most likely causes of intermittent hangs under load in an ASP.NET Core app, plus the concrete fixes I would apply first.

## Most likely failure modes

1. Sync-over-async in the request path is starving the thread pool. Typical offenders are `.Result`, `.Wait()`, `GetAwaiter().GetResult()`, synchronous EF/database calls, synchronous HTTP/file I/O, and blocking waits such as `SemaphoreSlim.Wait()`.
2. Fire-and-forget work is being started from controllers, endpoints, or middleware with `_ = SomeAsync()`, `Task.Run`, timers, or ad hoc queues, and that work is touching scoped services after the request has ended.
3. DI lifetime mismatches are promoting request-scoped state to effectively singleton state. The usual corpses are `DbContext`, per-request caches, current-user/request context, or repositories captured by singleton services or hosted services.
4. Background work is unbounded. Under load, too many concurrent jobs pile up, hold connections, and pin the thread pool until the app looks hung.
5. Cancellation and timeout handling is weak or absent, so slow downstream calls accumulate until every request is waiting on something that should have been cut loose much earlier.

## Concrete fixes

### 1. Make the request path async end-to-end

- Remove all sync-over-async calls from the web path. Search for `.Result`, `.Wait(`, `GetAwaiter().GetResult()`, `Task.Run(` in controllers, middleware, filters, MediatR handlers, repositories, and service classes.
- Convert the full call chain to async instead of wrapping synchronous work with `Task.Run`. In ASP.NET Core, `Task.Run` is not a fix for I/O-bound code, it is usually just extra scheduling and extra pain.
- Flow `CancellationToken` from `HttpContext.RequestAborted` all the way into HTTP clients, EF Core, queue operations, and delays.
- If multiple downstream operations are independent, run them together with `Task.WhenAll()` instead of serial awaits.
- Do not `await` inside `lock`. If you need async coordination, use `SemaphoreSlim.WaitAsync()` or redesign the shared state so the lock disappears.

### 2. Fix DI lifetime violations aggressively

- Keep `DbContext`, unit-of-work objects, request-scoped caches, and anything that depends on request data as `Scoped`.
- Keep stateless, thread-safe helpers as `Singleton` only if they do not capture mutable request data and do not depend on scoped services.
- Do not inject scoped services into singletons, including hosted services. That bug often does not fail fast in the exact place you deserve.
- Turn on service provider validation in development, tests, and CI so scope bugs fail at startup instead of during production load.

```csharp
builder.Host.UseDefaultServiceProvider((context, options) =>
{
    options.ValidateScopes = true;
    options.ValidateOnBuild = true;
});
```

### 3. Stop doing background work from request handlers

- Replace ad hoc fire-and-forget work with a bounded queue and a dedicated `BackgroundService`.
- Create a fresh DI scope per dequeued work item by using `IServiceScopeFactory`. Do not cache scoped dependencies in the worker constructor.
- Bound queue length and worker concurrency so load sheds cleanly instead of degrading into a fake hang.
- If the work must survive app restarts or scale across instances, move it to a real external queue instead of pretending the web process is a job runner.
- On .NET 10, `BackgroundService.ExecuteAsync` now runs entirely on a background thread. If startup-critical work must block startup, move it to `StartAsync` or `IHostedLifecycleService` instead of relying on pre-`await` behavior in `ExecuteAsync`.

```csharp
public sealed class QueuedWorker(IServiceScopeFactory scopeFactory, Channel<WorkItem> channel, ILogger<QueuedWorker> logger)
    : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        await foreach (var item in channel.Reader.ReadAllAsync(stoppingToken))
        {
            using var scope = scopeFactory.CreateScope();
            var handler = scope.ServiceProvider.GetRequiredService<IWorkItemHandler>();
            await handler.HandleAsync(item, stoppingToken);
        }
    }
}
```

### 4. Add timeouts, backpressure, and observability

- Put explicit timeouts around downstream HTTP, queue, and database calls where the dependency can stall indefinitely.
- Retry only idempotent operations, and use bounded retries with backoff. Blind retries under saturation just turn a small fire into a tire fire.
- Add structured logs and traces around request start/end, dependency calls, background job enqueue/dequeue/complete/fail, and cancellation.
- Under load, watch thread pool counters and wait events. A rising thread count with collapsing latency usually points to blocking code and thread-pool starvation.

## Test strategy that would actually catch this again

### Unit tests

- Add focused tests for cancellation propagation, timeout behavior, and async coordination paths.
- Test background queue behavior with bounded capacity, including full-queue behavior and graceful shutdown.
- Use `TaskCompletionSource` to control slow dependencies deterministically. Do not use `Thread.Sleep`, because it turns tests into weather forecasts.

### Integration tests

- Use `WebApplicationFactory` or `TestServer` to exercise the real HTTP pipeline, DI container, middleware order, and shutdown behavior.
- Add startup tests that fail if scope validation catches a scoped-into-singleton dependency.
- Add request cancellation tests that abort the client request and assert downstream work is canceled.
- Add graceful shutdown tests that verify in-flight background work is either completed or abandoned according to an explicit policy.

### Concurrency and load regression tests

- Add a targeted concurrency test that holds one or more downstream dependencies open with `TaskCompletionSource`, issues many concurrent requests, and verifies the app still returns bounded failures or cancellations instead of hanging indefinitely.
- Run a small repeatable load test with `bombardier` or `k6` before and after the fix, and capture latency percentiles, failure rate, queue depth, thread count, and dependency timings.

## Execution order

1. Reproduce the hang under load with counters and traces enabled.
2. Remove sync-over-async and request-path fire-and-forget code.
3. Fix DI lifetime violations and enable scope validation in dev/test/CI.
4. Move durable or slow work to a bounded background queue or external worker.
5. Add cancellation, timeout, and concurrency regression tests.
6. Re-run load tests and compare latency, throughput, thread count, and queue depth before calling it fixed.

## What I would need for exact findings

If you want a code-specific review instead of a generalized one, provide `Program.cs`, service registrations, hosted services, one representative request handler, one representative repository or downstream client, and any trace or dump captured during the hang.

## References

- Microsoft Learn, [.NET dependency injection](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/overview)
- Microsoft Learn, [Use scoped services within a BackgroundService](https://learn.microsoft.com/en-us/dotnet/core/extensions/scoped-service)
- Microsoft Learn, [BackgroundService runs all of ExecuteAsync as a Task](https://learn.microsoft.com/en-us/dotnet/core/compatibility/extensions/10.0/backgroundservice-executeasync-task)
- Microsoft Learn, [Debug ThreadPool starvation](https://learn.microsoft.com/en-us/dotnet/core/diagnostics/debug-threadpool-starvation)
- Microsoft Learn, [Test ASP.NET Core MVC apps](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/test-asp-net-core-mvc-apps)
