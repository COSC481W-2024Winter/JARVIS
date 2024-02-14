class MockGPTService {
    Future<String> generateText({
    required String fullName,
    required String age,
    required String story,
  }) async {
    // Simulate sending data to GPT and receiving a response
    // This is where you would typically make an HTTP request to your GPT API
    String inputData = "my name is $fullName, I am $age years old, and my story is: $story";
    return Future.delayed(Duration(seconds: 1), () {
      return "Mock response from GPT: $inputData";
    });
  }
}