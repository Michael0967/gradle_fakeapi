@ignore
Feature: create a category and return its id

  Scenario:
    # random name so the slug never repeats
    * def uid = java.util.UUID.randomUUID().toString()
    * def payload = { name: 'test category ' + uid, image: 'https://placeimg.com/640/480/any' }
    Given url baseUrl
    And path 'categories'
    And request payload
    When method post
    Then status 201
    And match response.name == payload.name
    And match response == read('classpath:schemas/category.schema.json')
    # pass values back to the caller
    And def id = response.id
    And def name = response.name
