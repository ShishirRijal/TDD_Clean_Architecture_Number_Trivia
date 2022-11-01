import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/usecases/usecase.dart';

import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetRandomNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'shoud get trivia  from the repository',
    () async {
      //arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      //act
      // final result = await usecase.execute(number: tNumber);
      // after refactoring it with callable classes, it looks like this
      final result = await usecase(const NoParams());
      //assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
