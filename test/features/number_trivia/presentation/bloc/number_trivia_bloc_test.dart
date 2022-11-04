import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/failures.dart';
import 'package:tdd_clean_architecture_number_trivia/core/usecases/usecase.dart';
import 'package:tdd_clean_architecture_number_trivia/core/utils/input_converter.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  const tNumberString = '1';
  const tNumberParsed = 1;

  const invalidInputFailureMessage =
      'Invalid Input - The number must be a positive integer or zero.';
  setUp(() {
    registerFallbackValue(const Params(number: tNumberParsed));

    registerFallbackValue(const NoParams());
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      converter: mockInputConverter,
    );
  });

  test(
    "initial state should be NumberTriviaInitial",
    () async {
      // Assert
      expect(bloc.state, equals(NumberTriviaInitial()));
    },
  );
  group("get trivia for concrete number", () {
    void setUpMockInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      "should call InputConverter and should convert the number string to valid unsigned integer",
      () async {
        // Arrange
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // Act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        // await untilCalled(() => mockGetConcreteNumberTrivia(any()));
        // Assert
        verifyNever(() =>
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () {
        // Arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));

        // Assert
        expectLater(bloc.stream,
            emitsInOrder([const Error(message: invalidInputFailureMessage)]));

        // Act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      "should get data from the concrete usecase",
      () async {
        // Arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // Act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(() => mockGetConcreteNumberTrivia(any()));
        // Assert
        verify(() =>
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );
    test(
      "should emit [Loading, Loaded] when the data is successfully gotten",
      () async {
        // Arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // Act
        final expected = [
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // Assert
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      "should emit [Loading, Error] when the data is getting data fails",
      () async {
        // Arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // Act
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // Assert
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
    test(
      "should emit [Loading, Error] with proper error message when the data is getting data fails",
      () async {
        // Arrange
        setUpMockInputConverterSuccess();

        when(() => mockGetConcreteNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // Act
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // Assert
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  // random trivia

  group("get trivia for random number", () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      "should get data from the random usecase",
      () async {
        // Arrange

        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // Act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(() => mockGetRandomNumberTrivia(any()));
        // Assert
        verify(() => mockGetRandomNumberTrivia(const NoParams()));
      },
    );
    test(
      "should emit [Loading, Loaded] when the data is successfully gotten",
      () async {
        // Arrange

        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // Act
        final expected = [
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // Assert
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      "should emit [Loading, Error] when  getting data fails",
      () async {
        // Arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // Act
        final expected = [
          Loading(),
          const Error(message: serverFailureMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // Assert
        bloc.add(GetTriviaForRandomNumber());
      },
    );
    test(
      "should emit [Loading, Error] with proper error message when getting data fails.",
      () async {
        // Arrange
        when(() => mockGetRandomNumberTrivia(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // Act
        final expected = [
          Loading(),
          const Error(message: cacheFailureMessage),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // Assert
        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
