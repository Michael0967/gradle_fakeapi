@ignore
Feature: create a unique probe product for the filter scenarios

  Scenario:
    # random title so the title filter only hits this probe
    * def uid = java.util.UUID.randomUUID().toString()
    # fetch a real category, the seeded ids change every time the demo api resets
    Given url baseUrl
    And path 'categories'
    When method get
    Then status 200
    And def validCategoryId = response[0].id
    * def probe = { title: 'filter probe ' + uid, price: 25, description: 'probe', categoryId: validCategoryId, images: ['https://i.imgur.com/a.jpg'] }
    Given url baseUrl
    And path 'products'
    And request probe
    When method post
    Then status 201
    And match response == read('classpath:schemas/product.schema.json')
    # pass values back to the caller
    And def id = response.id
    And def title = probe.title
    And def price = probe.price
    And def categoryId = probe.categoryId
    And def categorySlug = response.category.slug
