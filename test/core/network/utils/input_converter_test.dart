import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture_number_trivia/core/utils/input_converter.dart';

class MockInputConverter extends InputConverter {}

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('string to unsigned int', () {
    test(
      "string return a integer when the string represents an unsigned integer",
      () async {
        // Arrange
        const String str = '123';
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, const Right(123));
      },
    );
    test(
      "string return a failure when string doesn't represent unsigned integer",
      () async {
        // Arrange
        const String str = 'dgr';
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
    test(
      "string return a failure when string doesn't represent negative integer",
      () async {
        // Arrange
        const String str = '-125';
        // Act
        final result = inputConverter.stringToUnsignedInteger(str);
        // Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
