<!-- markdownlint-disable MD013 -->

# Upgrades and Migrations

Use this file for framework upgrades, version modernization, legacy cleanup, and staged migration planning.

## Current source anchors

- [What's new in .NET 10](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-10/overview)
- [What's new in ASP.NET Core in .NET 10](https://learn.microsoft.com/en-us/aspnet/core/whats-new/)
- [Upgrade assistant and modernization docs](https://learn.microsoft.com/en-us/dotnet/core/porting/)
- [.NET Blog release notes](https://devblogs.microsoft.com/dotnet/)

## Default migration strategy

Prefer staged modernization over rewrites:

1. Understand the current architecture and deployment constraints
2. Upgrade the SDK and target framework
3. Fix package and analyzer fallout
4. Verify auth, routing, serialization, and observability
5. Modernize targeted pain points after the app is stable

Do not change framework version, SDK choice, or `LangVersion` casually. Check what the repo already declares.

## Upgrade checklist

- Inspect `global.json`
- Inspect all target frameworks and multi-targeting conditions
- Review central package management and transitive package effects
- Check CI and deployment images
- Read current release notes and breaking changes before “fixing” compile errors with guesses
- Compile and run tests before making stylistic modernizations

## High-value .NET 10 and ASP.NET Core 10 changes

These are the kinds of changes that should influence review and migration work:

- Minimal API validation now integrates cleanly with `IProblemDetailsService`
- SSE support is first-class via `TypedResults.ServerSentEvents(...)`
- ASP.NET Core auth and Identity observability improved with metrics
- Validation APIs moved into `Microsoft.Extensions.Validation`
- JSON Patch has a modern `System.Text.Json` implementation with major performance gains, but it is not a drop-in replacement for every legacy scenario
- Server memory pools now evict unused blocks more aggressively, improving idle-memory behavior

## Migration heuristics

### ASP.NET Core to newer ASP.NET Core

- Preserve the existing endpoint style first
- Upgrade packages and framework coherently
- Check auth and serialization before you chase smaller issues
- Revisit obsolete APIs, custom middleware, and custom binding or validation code

### Older ASP.NET or pre-Core systems

- Modernize incrementally
- Separate infrastructure migration from product behavior changes
- Put a reverse proxy or compatibility layer in front when it reduces risk
- Move shared contracts and DTOs carefully
- Rebuild auth flows deliberately, not as side effects of a port

### FastEndpoints repos

- Upgrade the base ASP.NET Core stack first
- Then verify FastEndpoints package compatibility and conventions
- Avoid “normalizing” the app back to controllers or minimal APIs during the upgrade unless the task explicitly includes that change

## Breaking-change handling

When you suspect a break:

1. Confirm it with current docs or source
2. Identify whether it is compile-time, runtime, hosting, auth, serialization, or deployment related
3. Propose the smallest viable fix
4. Call out behavior changes separately from mechanical fixes

## What good migration advice includes

- Current state summary
- Upgrade order
- Risk areas
- Verification plan
- Backout or containment strategy for risky steps

If the answer is just “rewrite it with the latest patterns,” the answer is bad.
