package org.example;

import io.karatelabs.junit6.Karate;

class ProductsTest {

    @Karate.Test
    Karate testProducts() {
        return Karate.run("products").relativeTo(getClass());
    }
}
