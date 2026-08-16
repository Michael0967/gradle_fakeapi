@users
Feature: Users

  Background:
    * url baseUrl

  Scenario: List registered users
    # password is plaintext here, it's a public demo api
    Given path 'users'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response == read('classpath:schemas/user.schema.json')

  Scenario: Create a user
    # shared by the scenarios below
    * def created = karate.callSingle('classpath:helpers/create-user.feature')

  Scenario: Fetch a user
    * def created = karate.callSingle('classpath:helpers/create-user.feature')
    Given path 'users', created.id
    When method get
    Then status 200
    And match response.name == created.name

  Scenario: Rename a user
    * def created = karate.callSingle('classpath:helpers/create-user.feature')
    Given path 'users', created.id
    When method get
    Then status 200
    And match response.name == created.name
    # only the name changes, the rest stays
    Given path 'users', created.id
    And request { name: 'test user update' }
    When method put
    Then status 200
    And match response.name == 'test user update'
    # fetch again to be sure
    Given path 'users', created.id
    When method get
    Then status 200
    And match response.name == 'test user update'

  Scenario: Email is already taken
    # john@mail.com is one of the seeded users
    Given path 'users', 'is-available'
    And request { email: 'john@mail.com' }
    When method post
    Then status 201
    And match response.isAvailable == false

  Scenario: Remove a user
    * def created = karate.callSingle('classpath:helpers/create-user.feature')
    Given path 'users', created.id
    When method get
    Then status 200
    And match response.id == created.id
    * print response
    Given path 'users', created.id
    When method delete
    Then status 200
    And match response == 'true'

  Scenario: User without a password
    Given path 'users'
    And request { name: 'no password user', email: 'nopass@mail.com' }
    When method post
    Then status 400

  Scenario: is-available rejects a malformed email
    Given path 'users', 'is-available'
    And request { email: 'not-an-email' }
    When method post
    Then status 400

  Scenario: Fetch a user that does not exist
    * def missingUserId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'users', missingUserId
    When method get
    Then status 400

  Scenario: Update a user that does not exist
    * def ghostUserId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'users', ghostUserId
    And request { name: 'x' }
    When method put
    Then status 400

  Scenario: Delete a user that does not exist
    * def fakeUserId = 1000000000 + Math.floor(Math.random() * 900000000)
    Given path 'users', fakeUserId
    When method delete
    Then status 400
