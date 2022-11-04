import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/exceptions.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('get last number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      "should return NumberTrivia from SharedPreferences when there is one in the cache",
      () async {
        // Arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(
          fixture('trivia_cached.json'),
        );
        // Act
        final result = await dataSource.getLastNumberTriviaModel();
        // Assert
        verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      },
    );
    test(
      "should throw CacheException from SharedPreferences when there is no cached trivia",
      () async {
        // Arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        // Act
        final call = dataSource.getLastNumberTriviaModel;
        // Assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cache number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      "should call shared preferences to cache the data",
      () async {
        // Arrange
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);
        // Act
        await dataSource.cacheNumberTrivia(tNumberTriviaModel);

        // Assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSharedPreferences.setString(
            cachedNumberTrivia, expectedJsonString));
      },
    );
  });
}
