@categories
Feature: Categories

  Background:
    * url baseUrl

  Scenario: List the categories
    Given path 'categories'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response == read('classpath:schemas/category.schema.json')

  Scenario: Create a category
    # the rest of the file reuses this one
    * def created = karate.callSingle('classpath:helpers/create-category.feature')

  Scenario: Fetch one category by id
    * def created = karate.callSingle('classpath:helpers/create-category.feature')
    # check the name we just created comes back
    Given path 'categories', created.id
    When method get
    Then status 200
    And match response.name == created.name

  Scenario: Rename a category
    * def created = karate.callSingle('classpath:helpers/create-category.feature')
    Given path 'categories', created.id
    When method get
    Then status 200
    And match response.name == created.name
    # update the name and keep the same image
    Given path 'categories', created.id
    And request { name: 'test category update', image: 'https://placeimg.com/640/480/any' }
    When method put
    Then status 200
    And match response.name == 'test category update'
    # reload and confirm
    Given path 'categories', created.id
    When method get
    Then status 200
    And match response.name == 'test category update'

  Scenario: Products inside a category
    * def created = karate.callSingle('classpath:helpers/create-category.feature')
    # a brand new category starts with no products
    Given path 'categories', created.id, 'products'
    When method get
    Then status 200
    And match response == '#[]'

  Scenario: Remove a category
    * def created = karate.callSingle('classpath:helpers/create-category.feature')
    Given path 'categories', created.id
    When method get
    Then status 200
    And match response.id == created.id
    * print response
    Given path 'categories', created.id
    When method delete
    Then status 200
    And match response == 'true'

  Scenario: Category without a name
    # only the image, the api should reject it
    Given path 'categories'
    And request { image: 'https://i.imgur.com/a.jpg' }
    When method post
    Then status 500

  Scenario: Fetch a missing category
    * def missingCatId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'categories', missingCatId
    When method get
    Then status 400

  Scenario: Update a missing category
    * def ghostCatId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'categories', ghostCatId
    And request { name: 'x', image: 'https://i.imgur.com/a.jpg' }
    When method put
    Then status 400

  Scenario: Delete a missing category
    * def fakeCatId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'categories', fakeCatId
    When method delete
    Then status 400
