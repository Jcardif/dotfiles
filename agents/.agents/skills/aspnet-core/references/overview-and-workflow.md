<!-- markdownlint-disable MD013 -->

# Overview and Workflow

Use this file when the task involves overall ASP.NET Core operating model decisions, repo shape, endpoint style selection, modernization stance, or architecture triage.

## Scope

This file governs:

- repo inspection before implementation
- architecture and endpoint-style decisions
- preservation versus modernization decisions
- response shape for architecture and repo-fit guidance

## Source radar

Use current primary sources first for unstable or version-specific details:

- [ASP.NET Core docs](https://learn.microsoft.com/en-us/aspnet/core/)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)
- [What's new in .NET 10](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-10/overview)
- [.NET Blog](https://devblogs.microsoft.com/dotnet/)

Use this reference to decide what guidance matters after you gather the current facts.

## Required pre-flight inspection

Before suggesting architecture or code changes, inspect:

- `global.json`
- `Directory.Build.props`, `Directory.Build.targets`, `Directory.Packages.props`
- application entrypoints such as `Program.cs`, `Startup.cs`, top-level routing, endpoint registration, or module registration
- project references and packages
- test projects, assertion libraries, and existing fixtures
- auth and hosting setup

Record these decisions before implementation or architectural advice:

1. Is this a new app, an existing ASP.NET Core app, or an older ASP.NET app being modernized?
2. Is the app API-first, MVC, Razor Pages, Blazor, or mixed?
3. Does the repo already commit to a framework style such as controllers, minimal APIs, or FastEndpoints?
4. Are there strong compatibility constraints such as legacy clients, generated SDKs, or older deployment assumptions?
5. Is the task preservation-focused or modernization-focused?

Do not implement until these are clear enough to avoid guessing about repo shape or compatibility constraints.

## Decision rules

### New API work

Start with the simplest built-in option that fits:

- minimal APIs for focused HTTP endpoints, small to medium APIs, and lightweight composition
- controllers when the repo already uses controllers, when filter conventions matter, or when the team wants a familiar class-based API structure
- FastEndpoints only when the repo already uses it or the task explicitly targets it

### Existing code

Prefer consistency over novelty:

- stay with controllers in controller-based repos unless there is a clear reason to add minimal APIs
- stay with minimal APIs in minimal API repos
- stay with FastEndpoints in FastEndpoints repos
- avoid style-mixing without a concrete payoff

### Modernization

Modernize incrementally:

- upgrade framework versions first
- replace dangerous or obsolete pieces next
- improve observability before risky refactors
- change endpoint style only if it solves a real maintenance or delivery problem

Do not turn an issue-scoped implementation task into modernization work just because a newer pattern exists.

## Staff-level heuristics

- respect the shipping system, the cleanest rewrite on paper is often the wrong move in a live app
- prefer built-in platform features before importing another abstraction layer
- keep the HTTP pipeline obvious, hidden behavior becomes production archaeology later
- push security, observability, and operability up front, not as a cleanup phase
- do not recommend architecture patterns because they sound senior, recommend them when they reduce real complexity

## Common repo smells

- controllers, minimal APIs, and custom endpoint wrappers all mixed together with no rule
- middleware ordered by folklore instead of dependency
- singleton services holding request-specific data
- hand-rolled auth flows when built-in handlers would do
- validation split inconsistently across attributes, filters, and ad hoc checks
- test suites that only prove mocks can return the values the test already told them to return

## Required workflow audit

Before finishing, review the task against this checklist:

- repo-shape audit: current app type, hosting model, and endpoint style were inspected
- pattern-fit audit: chosen programming model matches the repo unless modernization was explicitly requested
- compatibility audit: deployment, clients, packages, and legacy constraints were considered where relevant
- scope audit: the task did not widen into an unrelated rewrite or style migration
- reference audit: any task touching HTTP, security, testing, C#, FastEndpoints, or upgrades cross-loaded the matching reference file

## Required final reporting

When this file is loaded, the final response should state:

- current repo shape
- selected programming model or preservation stance
- key compatibility constraints, or that none were found
- whether the task was preservation, modernization, or unchanged repo fit
- any architecture decisions intentionally left unchanged

## Scope control

Do not recommend or implement:

- endpoint-style migrations without explicit task scope or a concrete breakage
- repo reorganizations just because another shape would be cleaner in theory
- large architectural rewrites when a local fix fits the repo
- modernization side quests that are unrelated to the requested work
