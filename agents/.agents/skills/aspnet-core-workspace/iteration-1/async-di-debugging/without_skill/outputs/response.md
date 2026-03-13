# Async, DI, and Background Work Review

No application source files were provided, so this is a pattern-level review
rather than a file-by-file code review. For an intermittent hang under load,
the most likely failures are in async usage, service lifetimes, and
unbounded background work.

## Findings

1. Critical: sync-over-async on hot paths is the first thing to kill.

   Look for `.Result`, `.Wait()`, `.GetAwaiter().GetResult()`, synchronous EF
   Core calls, synchronous HTTP/file I/O, or `Task.Run` wrapped around I/O from
   controllers, middleware, or services. Under load, those patterns block
   ThreadPool threads, which turns a small slowdown into request pileups and
   apparent hangs.

   Concrete fixes:

   - Make request handlers async end to end.
   - Replace sync data access with async APIs such as `ToListAsync`,
     `SaveChangesAsync`, and `SendAsync`.
   - Remove `Task.Run` around I/O-bound work. It does not make blocking code
     non-blocking.
   - Pass `CancellationToken` through every I/O boundary.

2. Critical: fire-and-forget work is probably escaping the request scope.

   Look for `_ = SomeAsync()`, `Task.Run` inside controllers, timers that can
   overlap, or background lambdas that capture scoped services. Those patterns
   drop exceptions, lose cancellation, and often keep using disposed
   dependencies after the request ends.

   Concrete fixes:

   - Move background work behind a bounded queue and a single place that owns
     execution.
   - Use `BackgroundService` plus `Channel<T>` or an equivalent bounded queue
     so publishers see backpressure instead of spawning infinite work.
   - Await every queued work item and log failures centrally.
   - If work must survive process restarts, use a durable broker instead of
     in-process fire-and-forget.

   A safe shape looks like this:

   ```csharp
   public sealed class QueuedWorker(
       IServiceScopeFactory scopeFactory,
       ChannelReader<WorkItem> reader) : BackgroundService
   {
       protected override async Task ExecuteAsync(
           CancellationToken stoppingToken)
       {
           await foreach (var item in reader.ReadAllAsync(stoppingToken))
           {
               await using var scope = scopeFactory.CreateAsyncScope();
               var handler = scope.ServiceProvider
                   .GetRequiredService<IWorkItemHandler>();

               await handler.HandleAsync(item, stoppingToken);
           }
       }
   }
   ```

3. High: a singleton is likely holding onto scoped state.

   The classic failure is a singleton service or hosted service directly taking
   `DbContext`, a repository built on `DbContext`, or any request-scoped
   dependency. That can produce disposed-object failures, data corruption, or
   weird hangs caused by cross-request contention.

   Concrete fixes:

   - Audit every `AddSingleton` registration and every `BackgroundService`
     constructor.
   - If the dependency is request-specific or unit-of-work-specific, make the
     consumer scoped.
   - In hosted services, inject `IServiceScopeFactory`, create a scope per
     iteration or per message, and resolve scoped services inside that scope.
   - Turn on scope validation in development and tests so lifetime bugs fail
     fast.

   ```csharp
   builder.Host.UseDefaultServiceProvider(options =>
   {
       options.ValidateScopes = true;
       options.ValidateOnBuild = true;
   });
   ```

4. High: mutable singleton state and blocking locks can create fake hangs.

   Look for singleton caches, shared `List<T>` or `Dictionary<TKey, TValue>`,
   `lock` blocks around I/O, `SemaphoreSlim.Wait()`, `ManualResetEventSlim`,
   or any shared queue implemented by hand. Those patterns often work in light
   traffic, then turn into contention hell once concurrency shows up.

   Concrete fixes:

   - Prefer stateless singletons.
   - Replace shared mutable collections with `ConcurrentDictionary` or
     `Channel<T>` when ownership is simple.
   - Never do network, database, or file I/O inside a `lock`.
   - Replace blocking waits with `WaitAsync`.
   - Cap concurrency explicitly if a downstream dependency cannot handle burst
     fan-out.

5. Medium: the current tests probably do not exercise the failure mode.

   If the test suite is mostly unit tests with mocked repositories and mocked
   HTTP clients, it can easily miss lifetime leaks, request abort behavior,
   queue saturation, and ThreadPool starvation. That is how teams end up with a
   green build and a production server that quietly chews through drywall.

   Concrete fixes:

   - Add integration tests with `WebApplicationFactory` so the real DI graph is
     exercised.
   - Use the real database provider when the bug depends on connection pooling,
     transaction behavior, or query concurrency.
   - Add parallel-request tests that issue enough concurrent calls to expose
     starvation and queue growth.
   - Add tests for request cancellation and host shutdown so background work is
     drained or cancelled intentionally.
   - Add regression tests that assert a scoped dependency is resolved inside a
     scope, not cached by a singleton.

## What I Would Change First

1. Grep for blocking and dropped-task patterns, then remove them:
   `.Result`, `.Wait(`, `.GetAwaiter().GetResult()`, `Task.Run(`, `async void`,
   `_ =`, `new Thread`, `Timer`, and synchronous EF or HTTP calls.
2. Replace ad hoc background work with a bounded queue and one hosted worker.
3. Audit `AddSingleton` registrations and every hosted service constructor for
   scoped dependencies or mutable state.
4. Enable DI scope validation in dev and test hosts.
5. Add a concurrency-focused integration test suite before changing more code.

## Diagnostics To Confirm It

- Run load against the slow endpoints and watch ThreadPool counters. If thread
  count ramps high and latency spikes, you likely have blocking work.
- Capture a trace during the bad window. In modern .NET, `WaitHandleWait`
  events are especially useful for spotting sync-over-async and blocking waits.
- Check whether queue depth, active background jobs, or database connection use
  grows without recovering.

## Assumptions and Gaps

- No source files were available, so I cannot point to exact registrations,
  controllers, or hosted services.
- If you want a real review instead of a pattern hit list, provide `Program.cs`
  or startup wiring, DI registrations, hosted services, and the request-path
  code that touches EF Core, HTTP clients, queues, or timers.

## Sources

- [ASP.NET Core performance best practices](https://learn.microsoft.com/en-us/aspnet/core/performance/performance-best-practices?view=aspnetcore-6.0#avoid-blocking-calls)
- [.NET dependency injection overview](https://learn.microsoft.com/en-us/dotnet/core/extensions/dependency-injection/overview)
- [Use scoped services within a BackgroundService](https://learn.microsoft.com/en-us/dotnet/core/extensions/scoped-service)
- [Background tasks with hosted services in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/host/hosted-services?view=aspnetcore-10.0)
- [Create a queue service](https://learn.microsoft.com/en-us/dotnet/core/extensions/queue-service)
- [Integration tests in ASP.NET Core](https://learn.microsoft.com/en-us/aspnet/core/test/integration-tests?view=aspnetcore-9.0)
- [Debug ThreadPool starvation](https://learn.microsoft.com/he-il/dotnet/core/diagnostics/debug-threadpool-starvation)
