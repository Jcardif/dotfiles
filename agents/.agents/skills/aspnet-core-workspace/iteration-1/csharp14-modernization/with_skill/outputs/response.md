<!-- markdownlint-disable MD013 -->

# Modernization Plan

Yes, modernize it. On a `.NET 10` API, older C# syntax and manual backing fields are usually just fossilized ceremony.

The right move is not "rewrite everything because new shiny." The right move is:

1. Confirm the repo is actually building with C# 14.
2. Upgrade obvious low-value old syntax.
3. Leave anything alone if the newer form is less readable in that specific spot.

## What I would change first

### 1. Make C# 14 the baseline

If the project is already on `.NET 10`, strongly prefer C# 14 as the default language version.

- Remove an unnecessary older `<LangVersion>` if one is pinning the repo back.
- If the repo explicitly sets a version, move it to `14.0` or a repo-approved equivalent.
- Do not keep an older language version out of habit.

### 2. Replace manual backing fields with `field`

This is one of the cleanest wins in C# 14.

Before:

```csharp
private string _name = string.Empty;

public string Name
{
    get => _name;
    set => _name = value.Trim();
}
```

After:

```csharp
public string Name
{
    get;
    set => field = value.Trim();
} = string.Empty;
```

Use this when the property only needs light validation, normalization, or coercion. If the property has more complex behavior, a named backing field may still be clearer.

### 3. Prefer primary constructors for simple DI-heavy types

Before:

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

After:

```csharp
public sealed class WeatherService(HttpClient httpClient, ILogger<WeatherService> logger)
    : IWeatherService
{
}
```

Use primary constructors when the type is mostly dependency capture plus behavior. If the constructor contains meaningful logic, validation, or multiple overloads, keep the regular constructor.

### 4. Use records for DTOs and transport shapes

Before:

```csharp
public class CreateOrderRequest
{
    public int CustomerId { get; init; }
    public string Reference { get; init; } = string.Empty;
}
```

After:

```csharp
public sealed record CreateOrderRequest(int CustomerId, string Reference);
```

Good fit:

- request and response models
- DTOs
- value-like option snapshots or messages

Bad fit:

- EF entities
- mutable domain objects
- framework-heavy types with awkward record semantics

### 5. Use null-conditional assignment where it genuinely removes boilerplate

Before:

```csharp
if (response is not null)
{
    response.TraceId = traceId;
}
```

After:

```csharp
response?.TraceId = traceId;
```

This is good when it shortens dead-simple guard-and-assign code. Do not use it if it hides important control flow.

### 6. Use collection expressions when the target type is obvious

Before:

```csharp
string[] roles = new[] { "admin", "user" };
List<string> scopes = new List<string> { "read", "write" };
```

After:

```csharp
string[] roles = ["admin", "user"];
List<string> scopes = ["read", "write"];
```

This is a straightforward readability win. Use it. Do not force it into places where the inferred target type becomes murky.

### 7. Prefer extension blocks over old extension-method sprawl for new grouped extensions

If the API already has a bag of unrelated static extension methods, C# 14 extension blocks are a cleaner way to group them.

Before:

```csharp
public static class OrderMappings
{
    public static OrderDto ToDto(this Order order) => new(order.Id, order.Number);
    public static OrderSummary ToSummary(this Order order) => new(order.Id, order.Number);
}
```

After:

```csharp
public static class OrderMappings
{
    extension(Order order)
    {
        public OrderDto ToDto() => new(order.Id, order.Number);
        public OrderSummary ToSummary() => new(order.Id, order.Number);
    }
}
```

This is worth using for cohesive groups. It is not worth rewriting every existing extension file just to flex on the compiler.

## What I would not churn just for modernization

- Stable code that is already clear and idiomatic enough
- Complex constructors that would get worse as primary constructors
- Properties where `field` makes validation logic harder to follow
- Types that should stay classes because they have identity or lifecycle
- Existing extension helpers that are already readable and not growing

## ASP.NET Core-specific guidance

In a `.NET 10` API, the highest-value modernization usually looks like this:

- DI-heavy services and endpoint helpers: move to primary constructors
- Request and response contracts: prefer records
- Normalizing properties: replace trivial backing fields with `field`
- Boilerplate null checks: use null-conditional assignment where obvious
- Small literals and setup code: use collection expressions
- New extension-based infrastructure helpers: prefer extension blocks

I would also keep these defaults while modernizing:

- prefer `TypedResults` over `Results`
- keep async all the way through request paths
- do not introduce clever LINQ or abstraction sludge while "modernizing"
- document public APIs if the contract is not obvious

## Practical rollout

Do this in small passes, not one giant syntax riot:

1. Set the language baseline to C# 14.
2. Convert manual backing fields that are clearly replaceable with `field`.
3. Convert obvious DTOs to records.
4. Convert simple constructor-injected types to primary constructors.
5. Use null-conditional assignment and collection expressions opportunistically while touching code.
6. Use extension blocks only for new or actively edited extension groups.

## Bottom line

For a `.NET 10` API, I would strongly recommend modernizing to idiomatic C# 14. The best wins are:

- primary constructors
- records for DTOs
- `field` instead of trivial backing fields
- null-conditional assignment
- collection expressions
- extension blocks for new grouped extension APIs

Use them where they make the code simpler to read. If a conversion makes the code feel like a language-demo slide, leave it alone.
