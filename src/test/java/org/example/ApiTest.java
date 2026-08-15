package org.example;

import io.karatelabs.junit6.Karate;

class ApiTest {

    @Karate.Test
    Karate products() {
        return Karate.run("classpath:features/products/products.feature");
    }
}
