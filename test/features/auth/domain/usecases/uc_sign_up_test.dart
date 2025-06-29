import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock sınıfları
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late UCSignUp useCase;
  late MockAuthRepository mockRepository;
  late MockUser mockUser;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockUser = MockUser();
    useCase = UCSignUp(repository: mockRepository);
  });

  group('UCSignUp', () {
    const tEmail = 'test@example.com';
    const tPassword = 'testPassword123';
    const tFullName = 'Test User';
    const tUsername = 'testuser';
    const tParams = SignUpParams(
      email: tEmail,
      password: tPassword,
      fullName: tFullName,
      username: tUsername,
    );

    test(
      "repository'den başarılı sonuç alınca Right(User) döndürmeli",
      () async {
        // Arrange
        when(
          () => mockRepository.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            username: any(named: 'username'),
          ),
        ).thenAnswer((_) async => Right(mockUser));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(Right<Failure, User>(mockUser)));
        verify(
          () => mockRepository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      const tFailure = AuthFailure('Email already exists');
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, equals(const Left<AuthFailure, User>(tFailure)));
      verify(
        () => mockRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("doğru parametrelerle repository'yi çağırmalı", () async {
      // Arrange
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => Right(mockUser));

      // Act
      await useCase(tParams);

      // Assert
      verify(
        () => mockRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).called(1);
    });

    test('SignUpParams eşitlik karşılaştırmasını doğru yapmalı', () {
      // Arrange
      const params1 = SignUpParams(
        email: 'test@example.com',
        password: 'pass',
        fullName: 'Test User',
        username: 'testuser',
      );
      const params2 = SignUpParams(
        email: 'test@example.com',
        password: 'pass',
        fullName: 'Test User',
        username: 'testuser',
      );
      const params3 = SignUpParams(
        email: 'different@example.com',
        password: 'pass',
        fullName: 'Different User',
        username: 'differentuser',
      );

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(
        params1.props,
        equals(['test@example.com', 'pass', 'Test User', 'testuser']),
      );
    });

    test(
      'internet connection failure durumunda Left(NoInternetFailure) döndürmeli',
      () async {
        // Arrange
        const tFailure = NoInternetFailure();
        when(
          () => mockRepository.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
            username: any(named: 'username'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left<NoInternetFailure, User>(tFailure)));
      },
    );

    test('weak password durumunda Left(AuthFailure) döndürmeli', () async {
      // Arrange
      const tFailure = AuthFailure('Password is too weak');
      when(
        () => mockRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          fullName: any(named: 'fullName'),
          username: any(named: 'username'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, equals(const Left<AuthFailure, User>(tFailure)));
    });
  });
}
