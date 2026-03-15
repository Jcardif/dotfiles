<!-- markdownlint-disable MD013 -->

# C Sharp

Use this file when the task involves C# in an ASP.NET Core or .NET codebase, especially for feature adoption, unfamiliar syntax, compatibility, DTO and type design, XML comments, API documentation, LINQ, dependency injection safety, or common anti-patterns. For test strategy, production diagnostics, or performance tuning, also load [Testing, Performance, and Diagnostics](testing-performance-and-diagnostics.md).

## Scope

This file governs:

- language-feature fit and compatibility
- type design and API documentation
- async API shape, LINQ, DI safety, and error-handling basics
- whether modern C# features are worth using for the current task

## Mental model

This file exists to steer the agent toward good C# code, code that is readable, maintainable, correct under load, and modern without being performative. Use newer language features when they remove ceremony or clarify intent. Do not import novelty, abstraction, or low-level tricks into ordinary web code just because the compiler allows it.

Treat newer C# features as tools, not a mandate. Do not widen a local task into a `LangVersion` or language-style modernization unless the task explicitly includes it, the repo already trends that way, or the change materially depends on the newer feature.

## Source anchors

- [What's new in C# 12](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-12)
- [What's new in C# 13](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-13)
- [What's new in C# 14](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-14)
- [C# language versioning](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/configure-language-version)
- [C# version history](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history)

## Compatibility gate

Before recommending modern C# syntax, verify:

- the target framework and SDK actually support the feature
- the repo's `LangVersion` and build setup allow it
- the codebase already uses comparable modern syntax, or the benefit is big enough to justify introducing it
- the feature solves a real readability, maintainability, or hot-path problem

Do not casually bump `LangVersion`. Do not recommend preview features unless the repo already opted into them on purpose.

## Required pre-flight inspection

Before implementation or recommendations, inspect:

- the repo's `LangVersion`, SDK, and target framework inputs
- whether the repo already uses the modern C# feature being considered
- public API surface and documentation conventions when reusable types are involved
- DI lifetimes, async patterns, and runtime constraints touched by the task

## Durable preferences

- Prefer small, focused types with one clear reason to change.
- Prefer primary constructors for straightforward DI-heavy services, handlers, middleware-adjacent types, and other simple constructor-injected types when they reduce ceremony and stay readable.
- Prefer records for DTOs, request models, response models, and other value-like transport shapes when mutability is not required.
- Prefer classes when the type has identity, mutable lifecycle, complex behavior, or framework constraints that make a record awkward.
- Prefer explicit, focused methods over clever fluent chains or abstraction stacks.
- Prefer `TypedResults` over untyped `Results` in minimal APIs.
- Prefer built-in platform features before another framework or another home-grown abstraction.

## API documentation

- Treat API documentation as part of the contract, not a cleanup chore.
- Audit every new or modified public type and public member before finishing.
- Reusable public APIs should be documented with XML comments. The default is to document them, not to debate whether the signature is "obvious enough."
- Complex or widely used internal APIs should also be documented when they would otherwise force readers to reverse-engineer intent.
- At minimum, document what the type or member does, important parameters, return behavior, notable exceptions, and non-obvious side effects.
- Use `<summary>` for the core contract, `<remarks>` for important extra behavior, `<param>` and `<returns>` for method contracts, and `<exception>` for failures callers are likely to encounter.
- Use `<see cref>`, `<paramref>`, and `<inheritdoc/>` when they improve accuracy and reduce drift.
- Use `<inheritdoc/>` when it keeps documentation honest and avoids copy-paste drift.
- Add examples when usage is easy to misuse or not obvious from the signature.
- Do not spam trivial members with useless comments that restate the name. The main exception to the documentation rule is trivial DTO/property accessors or members fully covered by accurate surrounding type-level docs or `<inheritdoc/>`.

## Quick reference: use this instead

| Anti-pattern | Prefer instead |
| --- | --- |
| `new HttpClient()` per operation | Inject `HttpClient` or `IHttpClientFactory` |
| `Results.Ok()` and friends | `TypedResults.Ok()` and typed result helpers |
| Hand-rolled Polly plumbing | `AddStandardResilienceHandler()` when the stack supports it |
| `DateTime.Now` for storage or comparison | `DateTime.UtcNow` or `DateTimeOffset.UtcNow` |
| `GetAsync().Result`, `.Wait()`, `.GetAwaiter().GetResult()` | `await GetAsync()` |
| Exceptions for normal control flow | Nullable, discriminated result, or repo-consistent result pattern |
| Manual backing fields for simple property logic | C# 14 `field` keyword when available |
| Traditional extension methods for new modern extension-based code | Extension blocks when the repo uses C# 14 and the grouping is worth it |
| `if (x != null) x.Prop = y;` | `x?.Prop = y` when it improves clarity |
| Missing `.ValidateOnStart()` on required options | Add `.ValidateOnStart()` for startup-critical options |
| Scoped service injected into singleton | `IServiceScopeFactory` or `IServiceProvider.CreateAsyncScope()` |
| `_count++` on shared singleton state | `Interlocked.Increment(ref _count)` |

## C# 12 to C# 14 features that are actually useful

### Usually worth adopting

#### Primary constructors (C# 12)

Great for simple DI-heavy types and other classes where the constructor exists mostly to capture dependencies or configuration. They reduce noise and make intent obvious when the type stays small.

Recommendation: generally worth adopting for straightforward service and handler types.

#### Collection expressions (C# 12)

Useful for concise array, list, and span initialization. Good when they make setup code easier to scan and there is no ambiguity about the target type.

Recommendation: generally worth adopting when the target collection type is obvious.

#### `field`-backed properties (C# 14)

Useful when a property needs simple validation or normalization logic without dragging in a named backing field.

Recommendation: generally worth adopting when it removes ceremony and stays obvious.

#### Null-conditional assignment (C# 14)

Useful when it removes repetitive guard-and-assign code without hiding control flow.

Recommendation: generally worth adopting when it clearly shortens boilerplate.

#### `nameof` support for unbound generic types (C# 14)

Useful in diagnostics, validation, metadata, and infrastructure code that talks about generic types directly.

Recommendation: generally worth adopting where generic type names are part of the code's vocabulary.

### Situational

#### Extension members and extension blocks (C# 14)

Useful when extension-based APIs are actually the right shape and related members benefit from being grouped together. They are better than old-school extension-method sprawl for new C# 14 code, but they can still hide ownership and encourage cleverness.

Recommendation: use selectively, mostly for library or infrastructure code where the organizational payoff is real.

#### Implicit `Span<T>` and `ReadOnlySpan<T>` conversions (C# 14)

Useful in parsing, serialization, protocol handling, and other measured hot paths. In normal endpoint code they are usually noise.

Recommendation: use selectively, mostly in measured hot paths or infrastructure code.

#### `params` collections (C# 13)

Useful for APIs that genuinely benefit from accepting a wider set of collection shapes. This matters more in reusable libraries than in ordinary application code.

Recommendation: use selectively where API ergonomics clearly improve.

#### `System.Threading.Lock` semantics (C# 13)

Useful in concurrency-sensitive code that already needs locking and can benefit from the newer lock semantics. This is not everyday web-application syntax.

Recommendation: use selectively in explicit concurrency-heavy infrastructure code.

#### Partial properties and partial indexers (C# 13)

Useful in source-generation or framework-driven scenarios. Rarely relevant to normal ASP.NET Core endpoint or service code.

Recommendation: use selectively when generation or tooling requires them.

#### Optional parameters in lambdas and method groups (C# 12)

Useful in some delegate-heavy APIs and route-handler shapes, but not a reason to churn ordinary code.

Recommendation: use selectively when it truly clarifies the handler or delegate contract.

### Mostly not worth the churn

#### Alias any type (C# 12)

Can be useful, but often adds another layer of naming indirection without real payoff in ordinary application code.

Recommendation: usually not worth introducing unless it simplifies a genuinely ugly type surface.

#### Inline arrays and other low-level features (C# 12)

These are for specialized performance and interop scenarios, not normal ASP.NET Core code.

Recommendation: usually irrelevant unless you are writing hot-path infrastructure and have measurements to justify it.

#### Ref-heavy, unsafe, or niche generic improvements (mostly C# 13)

These matter for advanced infrastructure, libraries, or interop-heavy code. They are not the default answer for API, service, or middleware code.

Recommendation: usually leave these alone unless the task is explicitly low-level.

#### Partial constructors, partial events, and compound assignment operators (C# 14)

These are real features, but they rarely justify broad adoption in ordinary ASP.NET Core code.

Recommendation: usually not worth introducing unless a tooling, generation, or domain-specific operator scenario clearly requires them.

## Async API defaults

- Use the `Async` suffix for async methods, except where framework conventions already define the shape.
- Return `Task<T>` for async methods that produce a value and `Task` for those that do not.
- Use `ValueTask` only when measurement, allocation pressure, or an established API surface justifies it.
- Avoid `async void` except true event handlers.
- Prefer TAP-style async APIs for reusable public async surfaces.

For async operational guidance in request paths, cancellation, concurrency, and diagnostics, load [Testing, Performance, and Diagnostics](testing-performance-and-diagnostics.md).

## LINQ guidance

- Use LINQ when it clarifies the transformation or query shape.
- Stop when the query becomes harder to read than a loop.
- Watch for multiple enumeration.
- Know when LINQ is in-memory and when it translates to the database.
- In EF Core, shape queries deliberately to avoid N+1 problems and accidental over-fetching.
- Prefer projections and includes that match the actual response contract.

Common smell:

- Layered LINQ chains that look elegant and hide terrible query behavior

## Dependency injection and runtime correctness

- Do not capture scoped services inside singletons.
- Use primary constructors for simple DI when the repo is already modern-C# friendly.
- Prefer explicit dependencies over service locator patterns.
- If a singleton truly needs scoped work, create a scope on demand.
- Be suspicious of mutable shared state in singleton services.

## Error handling and control flow

- Do not use exceptions for normal branching.
- Choose precise exception types for real exceptional failures.
- Do not swallow exceptions.
- If the repo already uses a result type such as `ErrorOr<T>` or another result pattern, stay consistent with it instead of inventing a competing style.
- If the repo does not use a result library, a nullable or explicit domain result is often enough.

## Data and type design

- Prefer records for DTOs, request models, response models, and other transport shapes where value semantics help.
- Prefer immutable defaults unless the framework or serializer requires mutable members.
- Do not expose internal mutable collections directly.
- Use UTC for storage and comparisons unless the requirement is explicitly local-time aware.

## Strong smells

- `new HttpClient()` scattered through services
- Sync-over-async in request paths
- Broad `catch (Exception)` with no meaningful handling
- Mutable singleton state with no thread-safety
- Result types, exceptions, and nulls all mixed as competing error contracts
- DTOs as giant mutable bags with accidental behavior
- Extension helpers that hide core logic instead of clarifying it
