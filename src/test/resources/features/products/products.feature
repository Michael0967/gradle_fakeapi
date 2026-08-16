@products
Feature: Products

  Background:
    * url baseUrl

  Scenario: Create a product
    # one shared product for the scenarios below
    * def created = karate.callSingle('classpath:helpers/create-product.feature')

  Scenario: Fetch a product by id
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # make sure the same title comes back
    Given path 'products', created.id
    When method get
    Then status 200
    And match response.title == created.title

  Scenario: Look up a product by its slug
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # first fetch the product to get its slug
    Given path 'products', created.id
    When method get
    Then status 200
    And def productSlug = response.slug
    Given path 'products', 'slug', productSlug
    When method get
    Then status 200
    And match response.id == created.id

  Scenario: Update a product
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    Given path 'products', created.id
    When method get
    Then status 200
    And match response.title == created.title
    # the api 500s on partial bodies, so send the whole thing
    Given path 'products', created.id
    And request { title: 'test product update', price: 20, description: 'Update by the Michael automation', categoryId: 1, images: ['https://i.imgur.com/b.jpg'] }
    When method put
    Then status 200
    And match response contains { title: 'test product update', price: 20, description: 'Update by the Michael automation' }
    # fetch again and check it stuck
    Given path 'products', created.id
    When method get
    Then status 200
    And match response contains { title: 'test product update', price: 20, description: 'Update by the Michael automation' }

  Scenario: Related products (by id)
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # other products in the same category
    Given path 'products', created.id, 'related'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response == read('classpath:schemas/product.schema.json')

  Scenario: Related products (by slug)
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # same thing but resolving from the slug this time
    Given path 'products', created.id
    When method get
    Then status 200
    And def productSlug = response.slug
    Given path 'products', 'slug', productSlug, 'related'
    When method get
    Then status 200
    And match response == '#[]'

  Scenario: List all products
    # also validates the shape of every single item
    Given path 'products'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response == read('classpath:schemas/product.schema.json')

  Scenario: Products list with pagination
    Given path 'products'
    And param offset = 0
    And param limit = 10
    When method get
    Then status 200
    And match response == '#[]'
    * assert response.length <= 10

  Scenario: Delete a product
    * def created = karate.callSingle('classpath:helpers/create-product.feature')
    # keep a copy of what we remove
    Given path 'products', created.id
    When method get
    Then status 200
    And match response.id == created.id
    * print response
    Given path 'products', created.id
    When method delete
    Then status 200
    # the api answers with a plain "true"
    And match response == 'true'

  Scenario: Create a product missing required fields
    Given path 'products'
    And request { title: 'no price or category here' }
    When method post
    Then status 500

  Scenario: Create a product with a bad categoryId
    Given path 'products'
    And request { title: 'bad category product', price: 5, description: 'x', categoryId: 999999, images: ['https://i.imgur.com/a.jpg'] }
    When method post
    Then status 400

  Scenario: Fetch a product that does not exist
    * def missingId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', missingId
    When method get
    Then status 400

  Scenario: Fetch by a slug that does not exist
    * def ghostSlug = 'this-slug-does-not-exist-' + java.util.UUID.randomUUID().toString()
    Given path 'products', 'slug', ghostSlug
    When method get
    Then status 400

  Scenario: Update a product that does not exist
    * def ghostId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', ghostId
    And request { title: 'x', price: 1, description: 'x', categoryId: 1, images: ['https://i.imgur.com/a.jpg'] }
    When method put
    Then status 400

  Scenario: Delete a product that does not exist
    * def fakeId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', fakeId
    When method delete
    Then status 400

  Scenario: Related products of a nonexistent id
    * def ghostId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'products', ghostId, 'related'
    When method get
    Then status 400
