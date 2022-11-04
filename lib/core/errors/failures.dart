import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.

  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object?> get props => [List];
}

// genereal failures
/// Here are some of the [General Failures] that may be encountered

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
