@ignore
Feature: create a user and return its id

  Scenario:
    # random email so it never repeats
    * def uid = java.util.UUID.randomUUID().toString()
    * def payload = { name: 'test user ' + uid, email: 'test.user.' + uid + '@mail.com', password: '1234', avatar: 'https://picsum.photos/800' }
    Given url baseUrl
    And path 'users'
    And request payload
    When method post
    Then status 201
    And match response.name == payload.name
    And match response == read('classpath:schemas/user.schema.json')
    # pass values back to the caller
    And def id = response.id
    And def name = response.name
