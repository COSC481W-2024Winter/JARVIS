import 'package:flutter_test/flutter_test.dart';
import 'package:jarvis/backend/news_service.dart';

class FakeNewsRepository extends news_service {
  // Override the getTopNews method to return a fixed list of news contents for testing purpose
  @override
  Future<List<String>> getTopNews() async {
    return ['Fake News 1', 'Fake News 2', 'Fake News 3'];
  }
}

void main() {
  // Declare a variable to hold the news_service instance
  late news_service newsRepository;

  // Set up the test environment
  setUp(() {
    newsRepository = FakeNewsRepository();
  });

  // Test case to verify the getTopNews method
  test('getTopNews returns a list of news contents', () async {
    // Call the getTopNews method and store the result
    final newsContents = await newsRepository.getTopNews();

    // Verify that the result matches the expected list of news contents
    expect(newsContents, equals(['Fake News 1', 'Fake News 2', 'Fake News 3']));
  });
}