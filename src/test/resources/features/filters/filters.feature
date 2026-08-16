@filters
Feature: Filters

  Background:
    * url baseUrl

  Scenario: Title filter finds the probe product
    # fresh probe per scenario, deleted right after, so filters never depend on other features
    * def probe = karate.call('classpath:helpers/create-filter-probe.feature')
    Given path 'products'
    And param title = probe.title
    When method get
    Then status 200
    * assert response.some(x => x.id == probe.id)
    # leave the api clean
    Given path 'products', probe.id
    When method delete
    Then status 200

  Scenario: Price filter by exact match
    * def probe = karate.call('classpath:helpers/create-filter-probe.feature')
    Given path 'products'
    And param price = probe.price
    When method get
    Then status 200
    * assert response.some(x => x.id == probe.id)
    Given path 'products', probe.id
    When method delete
    Then status 200

  Scenario: Category filter
    * def probe = karate.call('classpath:helpers/create-filter-probe.feature')
    # every result has to belong to that category
    Given path 'products'
    And param categoryId = probe.categoryId
    When method get
    Then status 200
    * assert response.every(x => x.category.id == probe.categoryId)
    Given path 'products', probe.id
    When method delete
    Then status 200

  Scenario: Category slug filter
    * def probe = karate.call('classpath:helpers/create-filter-probe.feature')
    Given path 'products'
    And param categorySlug = probe.categorySlug
    When method get
    Then status 200
    * assert response.every(x => x.category.slug == probe.categorySlug)
    Given path 'products', probe.id
    When method delete
    Then status 200

  Scenario: Price range between 100 and 200
    Given path 'products'
    And param price_min = 100
    And param price_max = 200
    When method get
    Then status 200
    And match response == '#[]'
    * assert response.every(x => x.price >= 100)
    * assert response.every(x => x.price <= 200)

  Scenario: Title + price range + category combined
    * def probe = karate.call('classpath:helpers/create-filter-probe.feature')
    Given path 'products'
    And param title = probe.title
    And param price_min = 0
    And param price_max = 100
    And param categoryId = probe.categoryId
    When method get
    Then status 200
    * assert response.some(x => x.id == probe.id)
    Given path 'products', probe.id
    When method delete
    Then status 200

  Scenario: A filter that matches nothing
    # totally made up title, expect an empty list
    * def randomTitle = 'no-product-' + java.util.UUID.randomUUID().toString()
    Given path 'products'
    And param title = randomTitle
    When method get
    Then status 200
    And match response == '#[]'
