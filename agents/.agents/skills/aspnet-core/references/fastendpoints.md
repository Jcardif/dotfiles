<!-- markdownlint-disable MD013 -->

# FastEndpoints

Use this file only when the repo already uses FastEndpoints or the task explicitly targets FastEndpoints. It is a supported programming model, not the default recommendation for every ASP.NET Core API.

## Scope

This file governs:

- FastEndpoints repo detection and slice shape
- endpoint, validator, mapper, and DI conventions inside FastEndpoints
- FastEndpoints-specific testing and docs behavior
- when to cross-load host-level ASP.NET Core references

## Mental model

FastEndpoints is not "minimal APIs with different syntax." Treat it as an endpoint-first, vertical-slice-friendly framework built around REPR:

- Request
- Endpoint
- Response

The point is to keep the HTTP contract and slice-specific behavior together instead of smearing it across controllers, action filters, and generic service layers.

## Current source anchors

- [Docs](https://fast-endpoints.com/)
- [GitHub](https://github.com/FastEndpoints/FastEndpoints)

## Required pre-flight inspection

Before implementation or recommendations, inspect:

- `FastEndpoints` package references
- `AddFastEndpoints()` and `UseFastEndpoints()` wiring
- the repo's actual slice structure, validator usage, mapper usage, and DI style
- current exception-handling path and docs generation path
- existing FastEndpoints-specific tests when relevant

## How to recognize it in a repo

Look for:

- `FastEndpoints` package references
- `AddFastEndpoints()` in service registration
- `UseFastEndpoints()` in the HTTP pipeline
- endpoint classes inheriting from `Endpoint<TRequest>` or `Endpoint<TRequest, TResponse>`
- validators inheriting from `Validator<TRequest>`
- slice folders that group request, response, validator, mapper, and endpoint files around one feature
- FastEndpoints Swagger or testing packages

## Default repo shape

A healthy FastEndpoints slice usually contains some or all of:

- request DTO
- response DTO
- endpoint
- validator
- mapper
- slice-specific tests

Not every slice needs every piece, but the framework is at its best when the feature stays cohesive instead of being scattered.

## Vertical slices

Inspect the repo's FastEndpoints shape before making slice-architecture assumptions.

Good FastEndpoints work usually looks like:

- feature folder first
- request and response models local to the feature
- validator local to the feature
- mapping local to the feature when the mapping is feature-specific
- domain or application services shared only when they are truly shared
- small slice-owned types instead of one bloated feature bucket

## What not to force

Do not "clean up" a FastEndpoints repo by turning it into controllers with service classes everywhere.

Also do not force every slice to have:

- a repository just because the endpoint touches data
- a service class that only forwards one call
- a mapper class when direct mapping is clearer
- a generic base endpoint abstraction for no real gain

If the repo already chose a richer application layer, respect it. Do not add ceremony just because slice-local behavior makes you nervous.

## Endpoint guidance

- keep HTTP-specific orchestration in the endpoint
- keep request-shape validation in the validator
- keep real business rules and persistence concerns in domain or application services where that separation is real
- use FastEndpoints response helpers and error mechanisms consistently
- avoid bloated handlers that perform transport validation, domain logic, mapping, persistence, and side effects all inline

The endpoint should own the slice, not become a dumping ground.

## Validation guidance

FastEndpoints commonly uses FluentValidation-based validators.

Important runtime detail:

- validators are effectively singleton-style components, so they must stay stateless
- do not inject scoped or request-specific state into validators
- do not put mutable per-request data inside validators

Use validators for:

- request shape
- required fields
- format and range checks
- simple contract-level rules

Use endpoint or domain/application services for:

- business-rule checks
- database-backed uniqueness checks
- workflow rules that depend on current state

When business-rule validation fails inside the handler, use the framework's error APIs consistently. Do not duplicate the same rule in both validator and handler.

## Dependency injection

FastEndpoints supports property injection, constructor injection, and resolving dependencies inside handlers.

Guidance:

- match the repo's existing style first
- prefer the least surprising pattern for that codebase
- choose DI style based on repo convention, not generic DI ideology
- do not rewrite a working property-injection codebase just to satisfy DI dogma
- do not hide core dependencies behind service locator style unless the repo already embraces that pattern

## Exception handling

FastEndpoints has its own exception-handling hooks and default exception handler support.

Guidance:

- check whether the app already uses the framework's default exception handler before introducing custom middleware
- if the repo intentionally lets exceptions flow outward for centralized handling, respect that shape
- keep endpoint-level error responses and exception-based failures consistent with the repo's existing approach
- do not mix ad hoc `try/catch` noise, custom envelopes, and framework error handling in the same slice

## Configuration and grouping

Look for endpoint configuration groups or other shared endpoint configuration patterns before adding repeated route, auth, tag, or versioning boilerplate across slices.

If the repo uses configuration groups:

- keep common configuration there
- keep slice-specific configuration in the slice

Do not shove everything back into `Program.cs` if the repo already moved it out for clarity.

## OpenAPI and docs

FastEndpoints often uses its own Swagger integration packages and endpoint-level description hooks.

When reviewing or changing docs:

- confirm how document generation is wired
- keep endpoint descriptions aligned with real request and response behavior
- check whether custom error response or problem-details conventions already exist
- prefer Scalar only for new docs UI decisions or explicit docs UI modernization
- if the repo already uses another docs UI, preserve it unless the current setup is broken or the task explicitly includes replacing it
- if the repo already uses FastEndpoints Swagger support, keep the document generation path and focus on contract accuracy unless the task explicitly includes UI replacement

## Testing

FastEndpoints has framework-specific testing support. Use it when the repo already relies on it.

Prefer:

- integration-style tests for HTTP behavior and slice wiring
- real validators and real endpoint execution where practical
- slice-level test coverage instead of controller-style test decomposition
- fake external dependencies only when they are actually external
- tests organized around the feature slice, not around fake MVC-era layers

Do not normalize FastEndpoints tests into controller-era habits if the framework already gives the repo a better testing shape.

## Scaffolding and code generation

If the repo uses FastEndpoints scaffolding or follows the scaffolded slice shape, preserve it. The scaffold is valuable because it reinforces the full vertical slice: endpoint, DTOs, validator, mapper, and related files.

Do not flatten that structure just because it looks like "more files." In this framework, the extra structure often carries its weight.

## Interoperability with ASP.NET Core

FastEndpoints still runs on ASP.NET Core. Normal platform rules still apply:

- middleware ordering still matters
- authentication and authorization still matter
- logging, tracing, metrics, and health checks still matter
- options, configuration, and hosting rules still matter

If the task is really about one of those host-level concerns, cross-load the relevant ASP.NET Core reference instead of pretending FastEndpoints replaced the host framework.

Cross-load requirements:

- auth, authorization, cookies, bearer tokens, OIDC, CORS, CSRF, or secrets: load `auth-and-security.md`
- OpenAPI, middleware, validation behavior, routing, or HTTP pipeline concerns: load `apis-and-http.md`
- tests, diagnostics, performance, or async/background behavior: load `testing-performance-and-diagnostics.md`
- public API docs, C# feature choices, or DI/runtime shape: load `csharp.md`

## Required FastEndpoints audit

Before finishing, review the task against this checklist:

- repo-shape audit: the repo's actual FastEndpoints conventions were inspected before changing slice structure
- slice audit: feature organization stays cohesive without forcing fake layers or repo-wide reorganization
- validator audit: validators stay stateless and do not depend on scoped or mutable request data
- DI audit: the chosen dependency-injection style matches repo convention
- error-handling audit: exception and framework error paths stay consistent
- docs audit: endpoint docs match real behavior without pushing an unrelated docs UI migration
- test audit: slice-level tests or HTTP behavior tests were added or reviewed when observable behavior changed
- cross-load audit: host-level concerns loaded the relevant ASP.NET Core reference instead of staying isolated inside FastEndpoints prose

## Required final reporting

When this file is loaded, the final response should state:

- which FastEndpoints conventions were inspected
- whether slice shape, validators, DI style, and error handling were preserved or changed
- which host-level ASP.NET Core references were cross-loaded
- whether docs or tests were reviewed for the slice

## Scope control

Do not:

- assume every FastEndpoints repo wants the same slice structure without inspection
- rewrite property injection to constructor injection, or vice versa, as a side quest
- normalize a FastEndpoints repo into controller-era patterns just because they feel more familiar
- push a docs UI migration unless the task explicitly includes it
