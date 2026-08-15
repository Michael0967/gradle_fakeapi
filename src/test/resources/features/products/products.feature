# Product creation test against the escuelajs fake API.
#
# The title uses a random UUID because the API derives a unique slug from it:
# a second POST with the same title fails with a UNIQUE constraint error.

Feature: Product creation

  Background:
    * url baseUrl
    * def uid = java.util.UUID.randomUUID().toString()
    * def payload = { title: 'test product ' + uid, price: 25, description: 'created by the automation', categoryId: 1, images: ['https://i.imgur.com/b.jpg'] }

  Scenario: Create a product
    Given path 'products'
    And request payload
    When method post
    Then status 201
    And match response.title == payload.title
    And match response contains { price: 25 }
    And match response == read('classpath:schemas/product.schema.json')
