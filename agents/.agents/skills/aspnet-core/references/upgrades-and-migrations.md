<!-- markdownlint-disable MD013 -->

# Upgrades and Migrations

Use this file for framework upgrades, version modernization, legacy cleanup, and staged migration planning.

## Scope

This file governs:

- SDK, target framework, and `LangVersion` changes
- staged migration planning
- upgrade risk assessment and rollback planning
- modernization work that is explicitly in scope

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

## Required pre-flight inspection

- inspect `global.json`
- inspect all target frameworks and multi-targeting conditions
- review central package management and transitive package effects
- check CI and deployment images
- read current release notes and breaking changes before "fixing" compile errors with guesses
- compile and run tests before making stylistic modernizations

## High-value .NET 10 and ASP.NET Core 10 changes

These are the kinds of changes that should influence review and migration work:

- minimal API validation integrates cleanly with `IProblemDetailsService`
- SSE support is first-class via `TypedResults.ServerSentEvents(...)`
- ASP.NET Core auth and Identity observability improved with metrics
- validation APIs moved into `Microsoft.Extensions.Validation`
- JSON Patch has a modern `System.Text.Json` implementation with major performance gains, but it is not a drop-in replacement for every legacy scenario
- server memory pools now evict unused blocks more aggressively, improving idle-memory behavior

## Migration heuristics

### ASP.NET Core to newer ASP.NET Core

- preserve the existing endpoint style first
- upgrade packages and framework coherently
- check auth and serialization before chasing smaller issues
- revisit obsolete APIs, custom middleware, and custom binding or validation code

### Older ASP.NET or pre-Core systems

- modernize incrementally
- separate infrastructure migration from product behavior changes
- put a reverse proxy or compatibility layer in front when it reduces risk
- move shared contracts and DTOs carefully
- rebuild auth flows deliberately, not as side effects of a port

### FastEndpoints repos

- upgrade the base ASP.NET Core stack first
- then verify FastEndpoints package compatibility and conventions
- avoid "normalizing" the app back to controllers or minimal APIs during the upgrade unless the task explicitly includes that change

## Breaking-change handling

When you suspect a break:

1. Confirm it with current docs or source
2. Identify whether it is compile-time, runtime, hosting, auth, serialization, or deployment related
3. Propose the smallest viable fix
4. Call out behavior changes separately from mechanical fixes

## Required migration audit

Before finishing, review the task against this checklist:

- scope audit: upgrade or migration work was explicitly in scope, or the answer clearly stayed at recommendation level
- compatibility audit: SDK, target framework, packages, CI images, and deployment constraints were reviewed
- breaking-change audit: suspected breaks were checked against current docs or source before proposing fixes
- verification audit: compile, tests, and post-upgrade verification steps were identified or run where possible
- rollback audit: risky changes have a containment or backout plan

## Required final reporting

When this file is loaded, the final response should state:

- current version and target version, if relevant
- upgrade order
- main risk areas
- verification plan
- rollback or containment strategy for risky steps

## Scope control

Do not:

- smuggle an upgrade into an unrelated implementation task
- change `LangVersion`, SDK, or target framework casually
- rewrite the app with newer patterns when a staged migration is the real answer

## What good migration advice includes

- current state summary
- upgrade order
- risk areas
- verification plan
- backout or containment strategy for risky steps

If the answer is just "rewrite it with the latest patterns," the answer is bad.
