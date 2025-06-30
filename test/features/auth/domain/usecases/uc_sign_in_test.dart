import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock sınıfları
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late UCSignIn useCase;
  late MockAuthRepository mockRepository;
  late MockUser mockUser;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockUser = MockUser();
    useCase = UCSignIn(repository: mockRepository);
  });

  group('UCSignIn', () {
    const tEmail = 'test@example.com';
    const tPassword = 'testPassword123';
    const tParams = SignInParams(email: tEmail, password: tPassword);

    test(
      "repository'den başarılı sonuç alınca Right(User) döndürmeli",
      () async {
        // Arrange
        when(
          () => mockRepository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(mockUser));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(Right<Failure, User>(mockUser)));
        verify(
          () => mockRepository.signIn(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      const tFailure = AuthFailure('Invalid credentials');
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, equals(const Left<AuthFailure, User>(tFailure)));
      verify(
        () => mockRepository.signIn(email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      "doğru email ve password parametreleriyle repository'yi çağırmalı",
      () async {
        // Arrange
        when(
          () => mockRepository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => Right(mockUser));

        // Act
        await useCase(tParams);

        // Assert
        verify(
          () => mockRepository.signIn(email: tEmail, password: tPassword),
        ).called(1);
      },
    );

    test('SignInParams eşitlik karşılaştırmasını doğru yapmalı', () {
      // Arrange
      const params1 = SignInParams(email: 'test@example.com', password: 'pass');
      const params2 = SignInParams(email: 'test@example.com', password: 'pass');
      const params3 = SignInParams(
        email: 'different@example.com',
        password: 'pass',
      );

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1.props, equals(['test@example.com', 'pass']));
    });

    test(
      'internet connection failure durumunda Left(NoInternetFailure) döndürmeli',
      () async {
        // Arrange
        const tFailure = NoInternetFailure();
        when(
          () => mockRepository.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Left<NoInternetFailure, User>(tFailure)));
      },
    );
  });
}
