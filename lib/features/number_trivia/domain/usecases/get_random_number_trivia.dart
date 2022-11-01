import 'package:tdd_clean_architecture_number_trivia/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/usecases/usecase.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) {
    return repository.getRandomNumberTrivia();
  }
}
