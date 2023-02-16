import 'package:api_request/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'mock_demo_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('fetchUser', () {
    test('returns the Users if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/users')))
          .thenAnswer((_) async =>
              http.Response('{"id": 1, "email": "a", "name": "mock"}', 200));
      expect(await fetchUser(client), isA<Users>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/users')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(fetchUser(client), throwsException);
    });
  });
}
