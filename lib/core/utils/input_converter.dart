import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final result = int.parse(str);
      if (result < 0) throw const FormatException();
      // we are throwing format exception so that
      // it will be catched by the catch block immediately following it
      return Right(result);
    } on FormatException catch (_) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
