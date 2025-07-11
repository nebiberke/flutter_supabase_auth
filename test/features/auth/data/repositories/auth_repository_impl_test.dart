import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock classes
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockUser extends Mock implements User {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockUser mockUser;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockUser = MockUser();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // Test data
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tFullName = 'Test User';
  const tUsername = 'testuser';

  group('signIn', () {
    test(
      'should return User when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signIn(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => mockUser);

        // act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, Right<Failure, User>(mockUser as User));
        verify(
          () => mockRemoteDataSource.signIn(email: tEmail, password: tPassword),
        ).called(1);
      },
    );

    test('should return NoInternetFailure when device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(result, const Left<Failure, User>(NoInternetFailure()));
      verifyNever(
        () => mockRemoteDataSource.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    test('should return AuthFailure when AuthException is thrown', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signIn(email: tEmail, password: tPassword),
      ).thenThrow(
        const AuthException('Invalid credentials', code: 'invalid_credentials'),
      );

      // act
      final result = await repository.signIn(
        email: tEmail,
        password: tPassword,
      );

      // assert
      expect(
        result,
        Left<Failure, User>(AuthFailure.fromCode('invalid_credentials')),
      );
    });

    test(
      'should return UnknownFailure when a general exception is thrown',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signIn(email: tEmail, password: tPassword),
        ).thenThrow(Exception('Unknown error'));

        // act
        final result = await repository.signIn(
          email: tEmail,
          password: tPassword,
        );

        // assert
        expect(result, const Left<Failure, User>(UnknownFailure()));
      },
    );
  });

  group('signUp', () {
    test(
      'should return User when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).thenAnswer((_) async => mockUser);

        // act
        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        );

        // assert
        expect(result, Right<Failure, User>(mockUser as User));
        verify(
          () => mockRemoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).called(1);
      },
    );

    test('should return NoInternetFailure when device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );

      // assert
      expect(result, const Left<Failure, User>(NoInternetFailure()));
      verifyNever(
        () => mockRemoteDataSource.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
        ),
      );
    });

    test('should return AuthFailure when AuthException is thrown', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).thenThrow(
        const AuthException(
          'Email already exists',
          code: 'user_already_exists',
        ),
      );

      // act
      final result = await repository.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );

      // assert
      expect(
        result,
        Left<Failure, User>(AuthFailure.fromCode('user_already_exists')),
      );
    });

    test(
      'should return UnknownFailure when a general exception is thrown',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).thenThrow(Exception('Unknown error'));

        // act
        final result = await repository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        );

        // assert
        expect(result, const Left<Failure, User>(UnknownFailure()));
      },
    );
  });

  group('signOut', () {
    test(
      'should return Unit when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});

        // act
        final result = await repository.signOut();

        // assert
        expect(result, const Right<Failure, Unit>(unit));
        verify(() => mockRemoteDataSource.signOut()).called(1);
      },
    );

    test('should return NoInternetFailure when device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // act
      final result = await repository.signOut();

      // assert
      expect(result, const Left<Failure, Unit>(NoInternetFailure()));
      verifyNever(() => mockRemoteDataSource.signOut());
    });

    test('should return AuthFailure when AuthException is thrown', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.signOut()).thenThrow(
        const AuthException('Sign out failed', code: 'sign_out_failed'),
      );

      // act
      final result = await repository.signOut();

      // assert
      expect(
        result,
        Left<Failure, Unit>(AuthFailure.fromCode('sign_out_failed')),
      );
    });

    test(
      'should return UnknownFailure when a general exception is thrown',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.signOut(),
        ).thenThrow(Exception('Unknown error'));

        // act
        final result = await repository.signOut();

        // assert
        expect(result, const Left<Failure, Unit>(UnknownFailure()));
      },
    );
  });

  group('getCurrentUser', () {
    test(
      'should return User when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getCurrentUser()).thenReturn(mockUser);

        // act
        final result = await repository.getCurrentUser();

        // assert
        expect(result, Right<Failure, User>(mockUser as User));
        verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      },
    );

    test('should return null when no user is logged in', () async {
      // arrange
      when(() => mockRemoteDataSource.getCurrentUser()).thenReturn(null);

      // act
      final result = await repository.getCurrentUser();

      // assert
      expect(result, const Right<Failure, User?>(null));
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
    });

    test('should return AuthFailure when AuthException is thrown', () async {
      // arrange
      when(() => mockRemoteDataSource.getCurrentUser()).thenThrow(
        const AuthException(
          'Failed to get current user',
          code: 'get_user_failed',
        ),
      );

      // act
      final result = await repository.getCurrentUser();

      // assert
      expect(
        result,
        Left<Failure, User?>(AuthFailure.fromCode('get_user_failed')),
      );
    });

    test(
      'should return UnknownFailure when a general exception is thrown',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getCurrentUser(),
        ).thenThrow(Exception('Unknown error'));

        // act
        final result = await repository.getCurrentUser();

        // assert
        expect(result, const Left<Failure, User?>(UnknownFailure()));
      },
    );
  });
}
