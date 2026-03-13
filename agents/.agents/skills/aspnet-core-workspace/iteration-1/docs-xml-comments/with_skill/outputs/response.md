<!-- markdownlint-disable MD013 -->

# XML Documentation Review

I can do that, but I need the API project or the relevant files to review. Without the code, the honest answer is "not enough information", and making up XML comments would be useless noise.

When I review it, I will add XML documentation only where it improves the contract:

- Public controllers, endpoints, middleware, filters, and reusable extension methods
- Public or widely used service interfaces and concrete types
- Public options/configuration types when the settings are not self-explanatory
- DTOs and request/response models only when the contract, constraints, or semantics are not obvious from the shape

The documentation will stay disciplined:

- Use `<summary>` for the real contract, not a renamed copy of the method or type name
- Add `<param>`, `<returns>`, and `<exception>` where callers need them
- Use `<remarks>` or `<example>` only when there is important behavior, usage, or edge-case context
- Prefer `<inheritdoc/>` when it keeps interface and implementation docs aligned
- Skip boilerplate comments on trivial members whose names already tell the story

If you want the review done, send one of these:

- The ASP.NET Core project path
- The specific files to review
- A pasted code sample of the public and reusable APIs

Once I have the code, I can do the review properly and add the missing XML comments without turning the API into comment spam.
