Feature: Products API

  Background:
    * url 'https://api.escuelajs.co/api/v1'

  Scenario: GET all products
    Given path 'products'
    When method get
    Then status 200
    And assert karate.sizeOf(response) > 0
    And match each response contains
      """
      {
        id: '#number',
        title: '#string',
        price: '#number',
        description: '#string',
        category: '#object',
        images: '#array'
      }
      """
