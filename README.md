# gradle_fakeapi

API test automation with **Java + Gradle + Karate** against the public fake API of [escuelajs.co](https://api.escuelajs.co/api/v1).

## Requirements

- JDK 17 or later (tested with JDK 26)
- No need to install Gradle: the project uses the wrapper (`./gradlew`)

## What is covered

4 feature files, one per functional domain (44 scenarios in total):

| Feature | Tag | Scenarios |
|---|---|---|
| Products (CRUD + related + pagination) | `@products` | 16 |
| Filters (title, price, category, combined) | `@filters` | 7 |
| Categories | `@categories` | 10 |
| Users | `@users` | 11 |

Each feature includes negative tests (nonexistent resources, missing required data, invalid values).

## How to run all the tests

From the project root:

```bash
./gradlew clean test
```

## How to run a single feature

The runner is one method, so features are selected by tag with `-Dkarate.tags`:

```bash
./gradlew clean test -Dkarate.tags=@products
./gradlew clean test -Dkarate.tags=@filters
./gradlew clean test -Dkarate.tags=@categories
./gradlew clean test -Dkarate.tags=@users
```

Every run regenerates its own report, so you always see only what ran in that execution.

## How to see the reports

After any run, open the Karate HTML report in the browser:

```bash
open build/karate-reports/index.html
```

The test run generates two reports:

| Report | Path |
|---|---|
| Karate HTML report (the most useful one) | `build/karate-reports/index.html` |
| Gradle/JUnit report | `build/reports/tests/test/index.html` |

The Karate report shows every feature and scenario with the request and response of each HTTP call, including printed values (`* print`).
