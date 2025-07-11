import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late UCSignUp useCase;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    useCase = UCSignUp(repository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tFullName = 'Test User';
  const tUsername = 'testuser';
  const tSignUpParams = SignUpParams(
    email: tEmail,
    password: tPassword,
    fullName: tFullName,
    username: tUsername,
  );

  group('UCSignUp', () {
    test('should return User when sign up is successful', () async {
      // arrange
      when(
        () => mockAuthRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).thenAnswer((_) async => Right(mockUser));

      // act
      final result = await useCase(tSignUpParams);

      // assert
      expect(result, Right<Failure, User>(mockUser));
      verify(
        () => mockAuthRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when email already exists', () async {
      // arrange
      const tFailure = AuthFailure('Email already exists');
      when(
        () => mockAuthRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tSignUpParams);

      // assert
      expect(result, const Left<Failure, User>(tFailure));
      verify(
        () => mockAuthRepository.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tFullName,
          username: tUsername,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test(
      'should return NoInternetFailure when there is no internet connection',
      () async {
        // arrange
        const tFailure = NoInternetFailure();
        when(
          () => mockAuthRepository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tSignUpParams);

        // assert
        expect(result, const Left<Failure, User>(tFailure));
        verify(
          () => mockAuthRepository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return UnknownFailure when an unexpected error occurs',
      () async {
        // arrange
        const tFailure = UnknownFailure();
        when(
          () => mockAuthRepository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tSignUpParams);

        // assert
        expect(result, const Left<Failure, User>(tFailure));
        verify(
          () => mockAuthRepository.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
            username: tUsername,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });

  group('SignUpParams', () {
    test('should be equatable', () {
      // arrange
      const params1 = SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );
      const params2 = SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );
      const params3 = SignUpParams(
        email: 'other@test.com',
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );
      const params4 = SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: 'Other User',
        username: tUsername,
      );

      // assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1, isNot(equals(params4)));
    });

    test('props should contain all fields', () {
      // arrange
      const params = SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );

      // assert
      expect(params.props, [tEmail, tPassword, tFullName, tUsername]);
    });

    test('should have correct field values', () {
      // arrange
      const params = SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
        username: tUsername,
      );

      // assert
      expect(params.email, tEmail);
      expect(params.password, tPassword);
      expect(params.fullName, tFullName);
      expect(params.username, tUsername);
    });
  });
}
