<!-- markdownlint-disable MD013 -->

# Overview and Workflow

Use this file when you need the overall operating model for ASP.NET Core work. It tells you how to read the repo, how to choose between major web patterns, and when to modernize versus preserve.

## Source radar

Use current primary sources first for unstable or version-specific details:

- [ASP.NET Core docs](https://learn.microsoft.com/en-us/aspnet/core/)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)
- [What's new in .NET 10](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-10/overview)
- [.NET Blog](https://devblogs.microsoft.com/dotnet/)

Use this reference to decide what guidance matters after you gather the current facts.

## First-pass inspection

Before suggesting architecture or code changes, inspect:

- `global.json`
- `Directory.Build.props`, `Directory.Build.targets`, `Directory.Packages.props`
- Application entrypoints such as `Program.cs`, `Startup.cs`, top-level routing, endpoint registration, or module registration
- Project references and packages
- Test projects, assertion libraries, and existing fixtures
- Auth and hosting setup

Key questions:

1. Is this a new app, an existing ASP.NET Core app, or an older ASP.NET app being modernized?
2. Is the app API-first, MVC, Razor Pages, Blazor, or mixed?
3. Does the repo already commit to a framework style such as controllers, minimal APIs, or FastEndpoints?
4. Are there strong compatibility constraints such as legacy clients, generated SDKs, or older deployment assumptions?

## Decision rules

### New API work

Start with the simplest built-in option that fits:

- Minimal APIs for focused HTTP endpoints, small to medium APIs, and lightweight composition
- Controllers when the repo already uses controllers, when filter conventions matter, or when the team wants a familiar class-based API structure
- FastEndpoints only when the repo already uses it or the task explicitly targets it

### Existing code

Prefer consistency over novelty:

- Stay with controllers in controller-based repos unless there is a clear reason to add minimal APIs
- Stay with minimal APIs in minimal API repos
- Stay with FastEndpoints in FastEndpoints repos
- Avoid style-mixing without a concrete payoff

### Modernization

Modernize incrementally:

- Upgrade framework versions first
- Replace dangerous or obsolete pieces next
- Improve observability before risky refactors
- Change endpoint style only if it solves a real maintenance or delivery problem

## Staff-level heuristics

- Respect the shipping system. The cleanest rewrite on paper is often the wrong move in a live app.
- Prefer built-in platform features before importing another abstraction layer.
- Keep the HTTP pipeline obvious. Hidden behavior becomes production archaeology later.
- Push security, observability, and operability up front, not as a cleanup phase.
- Do not recommend architecture patterns because they sound senior. Recommend them when they reduce real complexity.

## Common repo smells

- Controllers, minimal APIs, and custom endpoint wrappers all mixed together with no rule
- Middleware ordered by folklore instead of dependency
- Singleton services holding request-specific data
- Hand-rolled auth flows when built-in handlers would do
- Validation split inconsistently across attributes, filters, and ad hoc checks
- Test suites that only prove mocks can return the values the test already told them to return

## Response shape

When advising on ASP.NET Core architecture, answer in this order:

1. Current repo shape
2. Recommended approach
3. Why it fits this repo
4. Risks or compatibility concerns
5. Implementation or verification steps
