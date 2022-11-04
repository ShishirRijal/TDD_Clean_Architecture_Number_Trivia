import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/failures.dart';
import 'package:tdd_clean_architecture_number_trivia/core/usecases/usecase.dart';
import 'package:tdd_clean_architecture_number_trivia/core/utils/input_converter.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const serverFailureMessage = 'Server Failure';
const cacheFailureMessage = 'Cache Failure';

const invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required InputConverter converter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = converter,
        super(NumberTriviaInitial()) {
    // on<GetTriviaForConcreteNumber>(_concreteTriviaEventHandler);

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await getRandomNumberTrivia(const NoParams());
      failureOrTrivia.fold(
        (failure) => emit(Error(
          message: _mapFailureToMessage(failure),
        )),
        (trivia) => emit(Loaded(trivia: trivia)),
      );
      // yield* _getLoadedOrEmptyState(failureOrTrivia);
    });

    on<GetTriviaForConcreteNumber>(
        (GetTriviaForConcreteNumber event, emit) async {
      final inputEither = converter.stringToUnsignedInteger(event.numberString);
      await inputEither.fold(
          (failure) async =>
              emit(const Error(message: invalidInputFailureMessage)),
          (integer) async {
        emit(Loading());

        final failureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));
        await failureOrTrivia.fold(
          (failure) async => emit(Error(
            message: _mapFailureToMessage(failure),
          )),
          (trivia) async => emit(Loaded(trivia: trivia)),
        );
      });
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return serverFailureMessage;
    case CacheFailure:
      return cacheFailureMessage;
    default:
      return 'Unexpected Error';
  }
}
