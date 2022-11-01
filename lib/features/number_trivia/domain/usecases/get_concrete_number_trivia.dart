import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/usecases/usecase.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/errors/failures.dart';
import '../entities/number_trivia.dart';

class GetConcreteNumberTrivia with Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  // Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
  //   return await repository.getConcreteNumberTrivia(number);
  // }

  // It will be quite reduntant to call .execute function on every usecase.
  // Dart supports callable classes which helps us to call the class directly.

  // So let's refactor our code with callable function
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
