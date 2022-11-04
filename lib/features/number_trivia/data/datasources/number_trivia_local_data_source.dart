import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/errors/exceptions.dart';

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTriviaModel();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<NumberTriviaModel> getLastNumberTriviaModel() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);

    return jsonString != null
        ? Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)))
        : throw CacheException();
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel numberTrivia) async {
    return sharedPreferences.setString(
        cachedNumberTrivia, json.encode(numberTrivia.toJson()));
  }
}
