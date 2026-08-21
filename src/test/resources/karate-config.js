function fn() {
    var config = {
        baseUrl: karate.properties['BASE_URL'] || java.lang.System.getenv('BASE_URL') || 'https://api.escuelajs.co/api/v1'
    };
    return config;
}
