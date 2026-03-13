# C# 14 modernization plan for a .NET 10 API

I would modernize this conservatively, not by turning the
codebase into a syntax petting zoo.

The obvious upgrades are the ones that reduce noise without
making the code harder to read:

- Replace manual backing fields with the C# 14 `field`
  keyword where the property still needs accessor logic.
- Use primary constructors for services, handlers, and
  simple infrastructure types when they only exist to
  capture dependencies.
- Prefer records for DTOs and response models when they are just data carriers.
- Replace verbose null checks with null-conditional
  assignment where it is clearer, for example
  `model?.Metadata = metadata;`.
- Use collection expressions and other newer syntax only
  where they make the code simpler, not more cryptic.

## What I would change

### 1. Manual backing fields to `field`

Old style:

```csharp
private string _name = string.Empty;

public string Name
{
    get => _name;
    set => _name = value?.Trim() ?? string.Empty;
}
```

Better in C# 14:

```csharp
public string Name
{
    get;
    set => field = value?.Trim() ?? string.Empty;
}
```

This keeps the useful setter logic and removes the pointless private field.

### 2. Constructor boilerplate to primary constructors

Old style:

```csharp
public sealed class WeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<WeatherService> _logger;

    public WeatherService(HttpClient httpClient, ILogger<WeatherService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }
}
```

Better:

```csharp
public sealed class WeatherService(
    HttpClient httpClient,
    ILogger<WeatherService> logger) : IWeatherService
{
}
```

If the type only stores injected dependencies, the primary
constructor is cleaner and more idiomatic.

### 3. DTO classes to records

Old style:

```csharp
public sealed class CreateOrderRequest
{
    public string CustomerId { get; init; } = string.Empty;
    public List<CreateOrderItemRequest> Items { get; init; } = [];
}
```

Better:

```csharp
public sealed record CreateOrderRequest(
    string CustomerId,
    List<CreateOrderItemRequest> Items);
```

For transport models, records usually fit better than
mutable classes unless the serializer or framework
constraints say otherwise.

### 4. Null checks to null-conditional assignment

Old style:

```csharp
if (response is not null)
{
    response.TraceId = traceId;
}
```

Better:

```csharp
response?.TraceId = traceId;
```

That is the kind of upgrade worth making because it removes
ceremony without changing intent.

## What I would not change blindly

- I would not force extension blocks everywhere just because C# 14 has them.
- I would not rewrite stable domain entities into records
  without checking equality and mutation semantics.
- I would not collapse multi-step logic into dense expressions just to look modern.
- I would not introduce niche syntax that the team will hate reading in six months.

## Safe modernization rules

- Prefer readability over novelty.
- Upgrade repeated boilerplate first.
- Keep endpoint and application code boring.
- Use newer syntax aggressively in DTOs, simple services,
  and straightforward plumbing.
- Be more conservative in domain logic,
  serialization-sensitive types, and hot paths.

## Recommended target patterns

In a .NET 10 API, the baseline I would aim for is:

- C# 14 enabled
- primary constructors for dependency-capturing types
- `field` instead of manual backing fields
- records for plain request and response DTOs
- null-conditional assignment where it improves clarity
- async all the way, no sync-over-async
- `DateTime.UtcNow` or `DateTimeOffset.UtcNow`, not `DateTime.Now`
- `TypedResults` in minimal APIs instead of older `Results.*` calls

If you want this applied to actual code, send the relevant
files and I would refactor only the parts where C# 14
clearly improves the code instead of doing a pointless
syntax migration for sport.
