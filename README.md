# gradle_fakeapi

API test automation with **Java + Gradle + Karate** against the public fake API of [escuelajs.co](https://api.escuelajs.co/api/v1).

## Requirements

- JDK 17 or later (tested with JDK 26)
- No need to install Gradle: the project uses the wrapper (`./gradlew`)

## Configuration: environment variables (`.env`)

All sensitive values (API keys, tokens, credentials) live in a `.env` file at the project root. **Never hardcode them in the source code and never commit this file** — it is already listed in `.gitignore`.

1. Create your local `.env` from the provided template:

   ```bash
   cp .env.example .env
   ```

2. Open `.env` and set the base URL of the API under test:

   ```dotenv
   # .env — DO NOT COMMIT THIS FILE
   BASE_URL=https://your-api.example.com
   ```

   | Variable | Purpose |
   |---|---|
   | `BASE_URL` | Base URL of the API under test |

3. That's it. `./gradlew test` loads `.env` automatically (see `build.gradle`) and `karate-config.js` exposes the value to every feature as `baseUrl`. It can also be overridden per run with a system property or a real environment variable:

   ```bash
   ./gradlew test -DBASE_URL=https://other-env.example.com
   ```

> **Security note**: if you ever need to share the project, share `.env.example` (safe, no secrets), never `.env`. If a real key is accidentally committed, rotate/revoke it immediately — deleting the file is not enough because it stays in git history.

## What is covered

4 feature files, one per functional domain (44 scenarios in total):

| Feature | Tag | Scenarios |
|---|---|---|
| Products (CRUD + related + pagination) | `@products` | 16 |
| Filters (title, price, category, combined) | `@filters` | 7 |
| Categories | `@categories` | 10 |
| Users | `@users` | 11 |

Each feature includes negative tests (nonexistent resources, missing required data, invalid values).

All responses are validated at every level: HTTP status code, response headers (`content-type`, `access-control-allow-origin`), body shape against JSON schemas (`src/test/resources/schemas/`), and the data returned by the service.

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

---

## Questions

### a. What were the main challenges you faced when implementing the functionalities?

The main challenge was understanding and correctly setting up the **Gradle** build structure. Having never worked with this build tool before, concepts like `build.gradle`, the wrapper (`gradlew`), dependency configuration, and JUnit 5 integration required an initial learning curve. However, with documentation and practice, these obstacles were overcome and allowed for a smooth development of the rest of the project.

### b. What testing techniques were used and what approach was given to automation?

**Karate DSL** on top of JUnit 5 was used as the API test automation framework. The techniques applied include:

- **Feature files with Gherkin**: Each functional domain (products, users, categories, filters) has its own `.feature` file with scenarios written in natural language.
- **Reusable helper features**: Auxiliary functions (`create-product.feature`, `create-user.feature`, etc.) encapsulate test data creation, avoiding duplication and easing maintenance.
- **Tags for organization**: Each feature has a tag (`@products`, `@users`, etc.) that allows selective execution of test subsets.
- **Automatic data cleanup**: In filter tests, a temporary product is created, used for validation, and immediately deleted afterwards, keeping the API clean.
- **Complete coverage**: Both positive tests (successful CRUD) and negative tests (nonexistent resources, missing data, invalid values) are included.

### c. How did you manage data validation and JSON response structure verification in your automated tests?

Validation was carried out across multiple layers:

1. **JSON schema validation**: Schemas were defined in `src/test/resources/schemas/` (`product.schema.json`, `user.schema.json`, `category.schema.json`) and applied using `match each response == read('classpath:schemas/product.schema.json')`. This verifies that every object in the response has the correct structure and data types.

2. **HTTP header validation**: Headers such as `content-type: application/json; charset=utf-8` and `access-control-allow-origin: *` are verified on every response.

3. **HTTP status code validation**: Each scenario validates the expected response code (200, 201, 404, etc.).

4. **Specific data validation**: `match` expressions are used to compare concrete values like `response.title == created.title` or `response.contains { price: 25 }`.

5. **Conditional validations with JavaScript**: Filter tests use expressions like `response.some(x => x.id == probe.id)` to verify that at least one element meets the condition.

### d. What learnings did you gain from developing this technical test and how do they contribute to your professional growth?

The main learnings were:

- **Gradle**: I understood the build lifecycle, dependency management, wrapper configuration, and how to integrate testing tools within its ecosystem. This knowledge is transferable to any Java project that uses Gradle.

- **Karate DSL**: I learned to express API tests in a declarative and readable way, which facilitates communicating software quality status to the team.

- **Designing maintainable tests**: Separating reusable helpers, using JSON schemas, and automatic data cleanup are practices I will apply in future automation projects.

- **Quality mindset**: Developing tests that cover both the happy path and edge cases strengthened my approach toward more robust and reliable development.

These learnings not only improve my technical capability but also reinforce good software engineering practices valued in the professional field.
