import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock sınıfları
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

  group('AuthRepositoryImpl', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tFullName = 'Test User';
    const tUsername = 'testuser';

    group('signIn', () {
      test(
        'internet bağlantısı varken başarılı signIn Right(User) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => mockUser);

          // Act
          final result = await repository.signIn(
            email: tEmail,
            password: tPassword,
          );

          // Assert
          expect(result, equals(Right<AuthFailure, User>(mockUser)));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(
            () =>
                mockRemoteDataSource.signIn(email: tEmail, password: tPassword),
          ).called(1);
        },
      );

      test(
        'internet bağlantısı yokken Left(NoInternetFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.signIn(
            email: tEmail,
            password: tPassword,
          );

          // Assert
          expect(
            result,
            equals(const Left<NoInternetFailure, User>(NoInternetFailure())),
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyNever(
            () => mockRemoteDataSource.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          );
        },
      );

      test(
        'AuthException yakalandığında Left(AuthFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(
            const AuthException(
              'Invalid credentials',
              code: 'invalid_credentials',
            ),
          );

          // Act
          final result = await repository.signIn(
            email: tEmail,
            password: tPassword,
          );

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<AuthFailure>()),
            (user) => fail('Expected failure'),
          );
        },
      );

      test(
        'NullResponseException yakalandığında Left(NullResponseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(NullResponseException());

          // Act
          final result = await repository.signIn(
            email: tEmail,
            password: tPassword,
          );

          // Assert
          expect(
            result,
            equals(
              const Left<NullResponseFailure, User>(NullResponseFailure()),
            ),
          );
        },
      );

      test(
        'generic Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signIn(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await repository.signIn(
            email: tEmail,
            password: tPassword,
          );

          // Assert
          expect(
            result,
            equals(const Left<UnknownFailure, User>(UnknownFailure())),
          );
        },
      );
    });

    group('signUp', () {
      test(
        'internet bağlantısı varken başarılı signUp Right(User) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              username: any(named: 'username'),
            ),
          ).thenAnswer((_) async => mockUser);

          // Act
          final result = await repository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          );

          // Assert
          expect(result, equals(Right<AuthFailure, User>(mockUser)));
          verify(() => mockNetworkInfo.isConnected).called(1);
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

      test(
        'internet bağlantısı yokken Left(NoInternetFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          );

          // Assert
          expect(
            result,
            equals(const Left<NoInternetFailure, User>(NoInternetFailure())),
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyNever(
            () => mockRemoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              username: any(named: 'username'),
            ),
          );
        },
      );

      test(
        'AuthException yakalandığında Left(AuthFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              username: any(named: 'username'),
            ),
          ).thenThrow(
            const AuthException('Email already exists', code: 'email_exists'),
          );

          // Act
          final result = await repository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          );

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<AuthFailure>()),
            (user) => fail('Expected failure'),
          );
        },
      );

      test(
        'NullResponseException yakalandığında Left(NullResponseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              username: any(named: 'username'),
            ),
          ).thenThrow(NullResponseException());

          // Act
          final result = await repository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          );

          // Assert
          expect(
            result,
            equals(
              const Left<NullResponseFailure, User>(NullResponseFailure()),
            ),
          );
        },
      );

      test(
        'generic Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              fullName: any(named: 'fullName'),
              username: any(named: 'username'),
            ),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await repository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          );

          // Assert
          expect(
            result,
            equals(const Left<UnknownFailure, User>(UnknownFailure())),
          );
        },
      );
    });

    group('signOut', () {
      test('başarılı signOut Right(Unit) döndürmeli', () async {
        // Arrange
        when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async {});

        // Act
        final result = await repository.signOut();

        // Assert
        expect(result, equals(const Right<AuthFailure, Unit>(unit)));
        verify(() => mockRemoteDataSource.signOut()).called(1);
      });

      test(
        'Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockRemoteDataSource.signOut(),
          ).thenThrow(Exception('Sign out failed'));

          // Act
          final result = await repository.signOut();

          // Assert
          expect(
            result,
            equals(const Left<UnknownFailure, Unit>(UnknownFailure())),
          );
          verify(() => mockRemoteDataSource.signOut()).called(1);
        },
      );
    });

    group('getCurrentUser', () {
      test('mevcut kullanıcıyı döndürmeli', () {
        // Arrange
        when(() => mockRemoteDataSource.getCurrentUser()).thenReturn(mockUser);

        // Act
        final result = repository.getCurrentUser();

        // Assert
        expect(result, equals(mockUser));
        verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      });

      test('kullanıcı yoksa null döndürmeli', () {
        // Arrange
        when(() => mockRemoteDataSource.getCurrentUser()).thenReturn(null);

        // Act
        final result = repository.getCurrentUser();

        // Assert
        expect(result, isNull);
        verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      });
    });
  });
}
