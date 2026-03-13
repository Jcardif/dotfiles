# Orders Feature Plan

I’ll keep this in FastEndpoints and add an `Orders` vertical slice
that matches the repo’s existing shape. No controllers, no
“helpful” conversion back to MVC, no generic service layer added
just to feel enterprise.

The slice should mirror the existing FastEndpoints pattern already
in the repo. In a healthy setup that usually means something like:

```text
Features/
  Orders/
    Create/
      CreateOrderRequest.cs
      CreateOrderResponse.cs
      CreateOrderValidator.cs
      CreateOrderEndpoint.cs
      CreateOrderMapper.cs        // only if mapping is non-trivial
      CreateOrderTests.cs
    GetById/
      GetOrderRequest.cs
      GetOrderResponse.cs
      GetOrderEndpoint.cs
      GetOrderTests.cs
```

The rules I’d follow while adding it:

- Keep request, response, validator, endpoint, and tests in the same feature slice.
- Match the repo’s existing DI style. If the codebase uses property
  injection in FastEndpoints, keep doing that. If it uses
  constructor injection, keep that instead.
- Keep HTTP orchestration in the endpoint.
- Keep request-shape validation in `Validator<TRequest>`.
- Keep actual business rules and persistence in existing shared
  domain or application services if the repo already has them.
- Do not add a repository, service, mapper, or base endpoint unless
  this repo already uses one and it is earning its keep.
- If the repo uses endpoint configuration groups for auth,
  versioning, or tags, plug the new Orders endpoints into that
  instead of duplicating route boilerplate.

For a new `CreateOrder` slice, the shape should be:

- `CreateOrderRequest`: transport DTO only, just the fields the
  endpoint needs.
- `CreateOrderResponse`: response DTO only, shaped for the HTTP
  contract.
- `CreateOrderValidator`: required fields, ranges, lengths, and
  contract-level rules. Keep it stateless.
- `CreateOrderEndpoint`: route, auth, orchestration, calling the
  existing order creation path, and returning the correct
  FastEndpoints response.
- `CreateOrderMapper`: only if the repo already uses mappers or the
  request-to-domain translation is messy enough to justify one.
- `CreateOrderTests`: slice-level tests covering validation,
  success path, and expected failure behavior.

I would also keep business validation out of the FluentValidation
validator when it depends on current state. For example:

- “customer id is required” belongs in the validator
- “customer cannot place an order while suspended” belongs in the
  handler or domain/application service
- “product is out of stock” belongs in the handler or downstream
  service, not duplicated in transport validation

If the repo already has an `Orders` feature folder, I’d extend that
instead of inventing a parallel structure. If it already uses naming
conventions like `Create.Endpoint.cs` or colocated request/response
records, I’d copy that style exactly. Consistency beats my personal
taste.

Testing should stay slice-oriented:

- validator tests for request-shape rules
- endpoint or integration-style tests for the HTTP contract and wiring
- fake only truly external dependencies
- do not decompose this into controller-style unit tests, because
  there are no controllers and there shouldn’t be

So the implementation plan is straightforward:

1. Find an existing FastEndpoints slice in the repo and copy its
   structure, naming, DI style, and test shape.
2. Add the new `Orders` slice files beside the existing features,
   not in a horizontal `Controllers/Services/Repositories` layout.
3. Wire routes, tags, auth, and versioning the same way the repo
   already does.
4. Reuse existing order/domain services if they exist, otherwise
   add only the smallest missing shared piece.
5. Add slice-level tests and keep the whole thing inside the FastEndpoints model.

That is the right move here. The wrong move is “this uses
FastEndpoints, but let me help by turning it into controllers.”
That would be vandalism with a NuGet package.
