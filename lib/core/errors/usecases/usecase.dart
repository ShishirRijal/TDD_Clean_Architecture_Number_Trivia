import 'package:dartz/dartz.dart';

import '../failures.dart';

abstract class Usecase<Type, Params> {
  // params here is a class which contains all the parameters required for the usecase
  // so we will define parameter class and pass it as a parameter to the call method,
  // inside which we will write all the required parameters for the usecase
  Future<Either<Failure, Type>> call(Params params);
}

// in case we need no parameters
class NoParams {
  const NoParams();
}
