import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/auth/data/models/auth_model.dart';
import 'package:flutter_supabase_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tFullName = 'Test User';

  const tAuthModel = AuthModel(
    userId: 'test_id',
    accessToken: 'test_token',
    providers: ['email'],
  );

  const tAuthEntity = AuthEntity(
    userId: 'test_id',
    accessToken: 'test_token',
    isTokenExpired: false,
    providers: ['email'],
  );

  group('signIn', () {
    test(
      'should return AuthEntity when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tAuthModel);

        // act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, equals(const Right<Failure, AuthEntity>(tAuthEntity)));
        verify(() => mockNetworkInfo.isConnected);
        verify(
          () => mockRemoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          ),
        );
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(
          result,
          equals(const Left<Failure, AuthEntity>(NoInternetFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return AuthFailure when AuthException occurs',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(const AuthException('Auth error'));

        // act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(
          result,
          equals(const Left<Failure, AuthEntity>(AuthFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verify(
          () => mockRemoteDataSource.signIn(
            email: tEmail,
            password: tPassword,
          ),
        );
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('signUp', () {
    test(
      'should return AuthEntity when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenAnswer((_) async => tAuthModel);

        // act
        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        // assert
        expect(result, equals(const Right<Failure, AuthEntity>(tAuthEntity)));
        verify(() => mockNetworkInfo.isConnected);
        verify(
          () => mockRemoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
        );
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        // assert
        expect(
          result,
          equals(const Left<Failure, AuthEntity>(NoInternetFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return AuthFailure when AuthException occurs',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenThrow(const AuthException('Auth error'));

        // act
        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
        );

        // assert
        expect(
          result,
          equals(const Left<Failure, AuthEntity>(AuthFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verify(
          () => mockRemoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
        );
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('signOut', () {
    test(
      'should return unit when call is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signOut())
            .thenAnswer((_) async => unit);

        // act
        final result = await repository.signOut();

        // assert
        expect(result, equals(const Right<Failure, Unit>(unit)));
        verify(() => mockRemoteDataSource.signOut());
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return UnknownFailure when Exception occurs',
      () async {
        // arrange
        when(() => mockRemoteDataSource.signOut()).thenThrow(Exception());

        // act
        final result = await repository.signOut();

        // assert
        expect(
          result,
          equals(const Left<Failure, Unit>(UnknownFailure())),
        );
        verify(() => mockRemoteDataSource.signOut());
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('authStateChanges', () {
    test(
      'should return stream of AuthEntity when call is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.authStateChanges)
            .thenAnswer((_) => Stream.value(tAuthModel));

        // act
        final stream = repository.authStateChanges;

        // assert
        await expectLater(
          stream,
          emits(const Right<Failure, AuthEntity?>(tAuthEntity)),
        );
        verify(() => mockRemoteDataSource.authStateChanges).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return AuthFailure when AuthException occurs',
      () async {
        // arrange
        when(() => mockRemoteDataSource.authStateChanges)
            .thenAnswer((_) => Stream.error(const AuthException('Auth error')));

        // act
        final stream = repository.authStateChanges;

        // assert
        await expectLater(
          stream,
          emits(const Left<Failure, AuthEntity?>(AuthFailure())),
        );
        verify(() => mockRemoteDataSource.authStateChanges).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return UnknownFailure when Exception occurs',
      () async {
        // arrange
        when(() => mockRemoteDataSource.authStateChanges)
            .thenAnswer((_) => Stream.error(Exception()));

        // act
        final stream = repository.authStateChanges;

        // assert
        await expectLater(
          stream,
          emits(const Left<Failure, AuthEntity?>(UnknownFailure())),
        );
        verify(() => mockRemoteDataSource.authStateChanges).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });
}
