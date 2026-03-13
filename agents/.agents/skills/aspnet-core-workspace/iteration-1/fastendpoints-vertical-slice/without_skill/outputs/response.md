<!-- markdownlint-configure-file { "MD013": false } -->

# Orders Feature

I would add the new Orders feature as a FastEndpoints vertical slice and keep it in the same feature-oriented structure the repo already uses. I would not convert anything to controllers.

Because the repository snapshot available in this eval does not include the actual FastEndpoints application code, I cannot safely patch the real project files from here without inventing paths and types. The correct implementation shape is still straightforward.

## Recommended slice shape

Add a dedicated `Orders` slice with the request, response, validator, endpoint, and tests kept together.

Example structure:

```text
Features/
  Orders/
    Create/
      CreateOrderEndpoint.cs
      CreateOrderRequest.cs
      CreateOrderResponse.cs
      CreateOrderValidator.cs
      CreateOrderTests.cs
```

If the repo uses a flatter slice layout, follow that instead of forcing this exact directory structure. The important bit is keeping the Orders feature self-contained and not scattering it across controller, model, and service folders like it is still 2017.

## Example implementation

### Request

```csharp
public sealed class CreateOrderRequest
{
    public required string CustomerId { get; init; }
    public required List<CreateOrderItemRequest> Items { get; init; }
}

public sealed class CreateOrderItemRequest
{
    public required string ProductId { get; init; }
    public required int Quantity { get; init; }
}
```

### Response

```csharp
public sealed class CreateOrderResponse
{
    public required string OrderId { get; init; }
    public required string Status { get; init; }
}
```

### Validator

```csharp
using FastEndpoints;
using FluentValidation;

public sealed class CreateOrderValidator : Validator<CreateOrderRequest>
{
    public CreateOrderValidator()
    {
        RuleFor(x => x.CustomerId)
            .NotEmpty();

        RuleFor(x => x.Items)
            .NotEmpty();

        RuleForEach(x => x.Items).ChildRules(items =>
        {
            items.RuleFor(x => x.ProductId)
                .NotEmpty();

            items.RuleFor(x => x.Quantity)
                .GreaterThan(0);
        });
    }
}
```

### Endpoint

```csharp
using FastEndpoints;

public sealed class CreateOrderEndpoint : Endpoint<CreateOrderRequest, CreateOrderResponse>
{
    public override void Configure()
    {
        Post("/orders");
        AllowAnonymous();
        Summary(s =>
        {
            s.Summary = "Creates a new order.";
            s.Description = "Creates a new order from the supplied customer and line items.";
            s.Response<CreateOrderResponse>(201, "Order created successfully.");
        });
    }

    public override async Task HandleAsync(CreateOrderRequest req, CancellationToken ct)
    {
        // Replace this with the repo's actual application/domain service.
        var orderId = Guid.NewGuid().ToString("N");

        var response = new CreateOrderResponse
        {
            OrderId = orderId,
            Status = "Created"
        };

        await SendAsync(response, StatusCodes.Status201Created, ct);
    }
}
```

## What I would preserve

- Keep the feature as a FastEndpoints slice.
- Keep validation in the slice validator.
- Keep the HTTP contract in request and response types close to the endpoint.
- Reuse the repo's existing application service or domain layer if one already exists.
- Add tests next to the slice or wherever the repo already keeps feature tests.

## What I would not do

- I would not add an MVC controller.
- I would not split this into controller, DTO, and service folders just because older ASP.NET habits die hard.
- I would not invent a generic repository or handler abstraction unless the repo already uses one consistently.

## Next step

If you want this implemented against the real app, point me at the FastEndpoints project files and the existing slice layout. Then I can add the Orders feature in the repo's actual structure instead of giving you the safe, generic shape above.
