@ignore
Feature: create a product and return its id

  Scenario:
    # random title so the slug never repeats
    * def uid = java.util.UUID.randomUUID().toString()
    * def payload = { title: 'test product ' + uid, price: 25, description: 'created by the Michael automation', categoryId: 1, images: ['https://i.imgur.com/b.jpg'] }
    Given url baseUrl
    And path 'products'
    And request payload
    When method post
    Then status 201
    And match response.title == payload.title
    And match response contains { price: 25, description: 'created by the Michael automation' }
    And match response == read('classpath:schemas/product.schema.json')
    # pass id and title back to the caller
    And def id = response.id
    And def title = response.title
