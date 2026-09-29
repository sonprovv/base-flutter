# Architecture

This starter uses feature-first Clean Architecture with pragmatic boundaries.

## Dependency direction

```text
presentation -> domain <- data
      |           ^       |
      +-----------|-------+
                  |
               core/app
```

Within a feature:

```text
Screen
  -> ViewModel (Riverpod)
    -> Use case (only when the business operation deserves a name)
      -> Repository interface (domain)
        <- Repository implementation (data)
          -> Remote/local data source
```

The domain layer never imports Flutter, Dio, secure storage, or UI code. Data implements domain contracts. Presentation consumes domain operations and maps asynchronous work into UI state.

## Folder rules

- `lib/app`: app composition, router, theme, bootstrap.
- `lib/core`: shared infrastructure with no feature-specific business logic.
- `lib/features/<feature>/domain`: entities, repository contracts, use cases.
- `lib/features/<feature>/data`: DTOs, mappers, data sources, repository implementations.
- `lib/features/<feature>/presentation`: screens and view models.

## Pragmatic rules

1. Do not create a use case for every repository method. Add one when it names business intent, composes repositories, enforces rules, or is reused.
2. Keep API DTOs out of presentation. Convert DTO -> domain entity in the data layer.
3. Repositories return `Result<T>` for expected operational failures. Programming errors are not hidden.
4. UI state belongs in presentation, not in repositories.
5. One feature must not import another feature's `data` or `presentation`. Share via domain contracts or move truly cross-cutting code into `core`.
6. Keep `core` small. If a class has feature meaning, it belongs to that feature.
7. Prefer constructor injection inside plain Dart classes. Riverpod providers are the composition root, not the business logic.
