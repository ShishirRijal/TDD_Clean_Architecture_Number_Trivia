import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/exceptions.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri());
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response("Something went wrong!!", 404));
  }

  group('get concrete number trivia', () {
    const tNumber = 1;

    test(
      "should perform a GET request on a URL with number being the endpoint and with application/json header",
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ));
      },
    );

    test(
      "should return ServerException when the response code is 404 or other than 200",
      () async {
        // Arrange
        setUpMockHttpClientFailure404();
        // Act
        final call = dataSource.getConcreteNumberTrivia;
        // Assert
        expect(
            () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  // random number trivia

  group('get random number trivia', () {
    test(
      "should perform a GET request on a URL with number being the endpoint and with application/json header",
      () async {
        // arrange
        setUpMockHttpClientSuccess200();

        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(() => mockHttpClient.get(
              Uri.parse('http://numbersapi.com/random'),
              headers: {'Content-Type': 'application/json'},
            ));
      },
    );

    test(
      "should return ServerException when the response code is 404 or other than 200",
      () async {
        // Arrange
        setUpMockHttpClientFailure404();
        // Act
        final call = dataSource.getRandomNumberTrivia;
        // Assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
