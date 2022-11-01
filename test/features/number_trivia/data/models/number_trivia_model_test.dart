import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('should be a subtype of NumberTriviaEntity', () async {
    // assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('from json', () {
    test(
      "Should return a valid model when the JSON number is an integer",
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));

        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });

  test(
    "Should return a valid model when the JSON number is regarded as double",
    () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);
      // assert
      expect(result, tNumberTriviaModel);
    },
  );

  test(
    "Should return a valid JSON containing proper data",
    () async {
      // Arrange
      // we already to have the tNumberTriviaModel.. So no arrangement neede
      // Act
      final result = tNumberTriviaModel.toJson();
      // Assert
      final expectedJson = {
        "text": "Test text",
        "number": 1,
      };
      expect(result, expectedJson);
    },
  );
}
