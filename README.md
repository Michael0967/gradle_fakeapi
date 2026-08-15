# gradle_fakeapi

API test automation with **Java + Gradle + Karate** against the public fake API of [escuelajs.co](https://api.escuelajs.co/api/v1).

## Requirements

- JDK 17 or later (tested with JDK 26)
- No need to install Gradle: the project uses the wrapper (`./gradlew`)

## How to run the tests

From the project root:

```bash
./gradlew test
```

To run a single test method:

```bash
./gradlew test --tests 'org.example.ApiTest.products'
```

## How to see the reports

The test run generates two reports:

| Report | Path |
|---|---|
| Karate HTML report (the most useful one) | `build/karate-reports/index.html` |
| Gradle/JUnit report | `build/reports/tests/test/index.html` |

To open the Karate report in the browser:

```bash
open build/karate-reports/index.html
```

The Karate report shows every scenario with the request and response of each HTTP call.
