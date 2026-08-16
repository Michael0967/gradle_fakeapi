Feature: Products

  Background:
    * url baseUrl

  Scenario: Create a product
    # this one product is reused by all the other scenarios
    * def created = karate.callSingle('classpath:helpers/create-product.feature')

  Scenario: Get a product by id
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # get the data back and check the title
    Given path 'products', created.id
    When method get
    Then status 200
    And match response.title == created.title

  Scenario: Update a product
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # get current data
    Given path 'products', created.id
    When method get
    Then status 200
    And match response.title == created.title
    # update the data
    Given path 'products', created.id
    And request { title: 'test product update', price: 20, description: 'Update by the Michael automation', categoryId: 1, images: ['https://i.imgur.com/b.jpg'] }
    When method put
    Then status 200
    And match response contains { title: 'test product update', price: 20, description: 'Update by the Michael automation' }
    # get it again and verify
    Given path 'products', created.id
    When method get
    Then status 200
    And match response contains { title: 'test product update', price: 20, description: 'Update by the Michael automation' }

  Scenario: Get all products
    # list is not empty and every item has the same shape
    Given path 'products'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response == read('classpath:schemas/product.schema.json')

  Scenario: Delete a product
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # show what we are about to delete
    Given path 'products', created.id
    When method get
    Then status 200
    And match response.id == created.id
    * print response
    Given path 'products', created.id
    When method delete
    Then status 200
    # delete only returns "true"
    And match response == 'true'

  Scenario: Create a product without required data
    Given path 'products'
    And request { title: 'product without required data' }
    When method post
    Then status 500

  Scenario: Get a nonexistent product
    * def missingId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', missingId
    When method get
    Then status 400

  Scenario: Update a nonexistent product
    * def ghostId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', ghostId
    And request { title: 'x', price: 1, description: 'x', categoryId: 1, images: ['https://i.imgur.com/a.jpg'] }
    When method put
    Then status 400

  Scenario: Delete a nonexistent product
    * def fakeId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', fakeId
    When method delete
    Then status 400
