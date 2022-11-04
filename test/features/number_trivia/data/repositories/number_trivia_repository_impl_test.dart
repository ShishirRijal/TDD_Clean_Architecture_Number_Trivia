import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/exceptions.dart';
import 'package:tdd_clean_architecture_number_trivia/core/errors/failures.dart';
import 'package:tdd_clean_architecture_number_trivia/core/network/network_info.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_clean_architecture_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRespositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRespositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const testNumber = 1;

    const testNumberTriviaModel = NumberTriviaModel(
      number: testNumber,
      text: 'test trivia',
    );

    const NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test('should check if the device is online', () {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
          .thenAnswer((_) async => testNumberTriviaModel);

      when(() => mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel))
          .thenAnswer((_) => Future<void>(() {}));

      // Act
      repository.getConcreteNumberTrivia(testNumber);

      // Assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      setUp(() {
        when(() => mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel))
            .thenAnswer((_) => Future<void>(() {}));
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => testNumberTriviaModel);

          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);

          // Assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(testNumber),
          );

          expect(result, equals(const Right(testNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => testNumberTriviaModel);

          // Act
          await repository.getConcreteNumberTrivia(testNumber);

          // Assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(testNumber),
          );

          verify(
            () => mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenThrow(ServerException());

          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);

          // Assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(testNumber),
          );

          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastNumberTriviaModel())
              .thenAnswer((_) async => testNumberTriviaModel);

          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTriviaModel());
          expect(result, const Right(testNumberTrivia));
        },
      );

      test(
        'should return cache failure when there is no cached data',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastNumberTriviaModel())
              .thenThrow(CacheException());

          // Act
          final result = await repository.getConcreteNumberTrivia(testNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTriviaModel());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('getRandomNumberTrivia', () {
    const testNumberTriviaModel = NumberTriviaModel(
      number: 123,
      text: 'test trivia',
    );

    const NumberTrivia testNumberTrivia = testNumberTriviaModel;

    test('should check if the device is online', () {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => testNumberTriviaModel);

      when(() => mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel))
          .thenAnswer((_) => Future<void>(() {}));

      // Act
      repository.getRandomNumberTrivia();

      // Assert
      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      setUp(() {
        when(() => mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel))
            .thenAnswer((_) => Future<void>(() {}));
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );

          expect(result, equals(const Right(testNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => testNumberTriviaModel);

          // Act
          await repository.getRandomNumberTrivia();

          // Assert
          verify(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );

          verify(
            () => mockLocalDataSource.cacheNumberTrivia(testNumberTriviaModel),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // Arrange
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verify(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          );

          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastNumberTriviaModel())
              .thenAnswer((_) async => testNumberTriviaModel);

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTriviaModel());
          expect(result, const Right(testNumberTrivia));
        },
      );

      test(
        'should return cache failure when there is no cached data',
        () async {
          // Arrange
          when(() => mockLocalDataSource.getLastNumberTriviaModel())
              .thenThrow(CacheException());

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTriviaModel());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
