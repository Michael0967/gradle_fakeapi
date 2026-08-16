package org.example;

import io.karatelabs.junit6.Karate;

class ApiTest {

    @Karate.Test
    Karate test() {
        String tags = System.getProperty("karate.tags");
        if (tags == null || tags.isEmpty()) {
            return Karate.run("classpath:features");
        }
        return Karate.run("classpath:features").tags(tags);
    }
}
