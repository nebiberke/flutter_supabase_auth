import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late UCSignIn useCase;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    useCase = UCSignIn(repository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tSignInParams = SignInParams(email: tEmail, password: tPassword);

  group('UCSignIn', () {
    test('should return User when sign in is successful', () async {
      // arrange
      when(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => Right(mockUser));

      // act
      final result = await useCase(tSignInParams);

      // assert
      expect(result, Right<Failure, User>(mockUser));
      verify(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure with invalid credentials', () async {
      // arrange
      const tFailure = AuthFailure('Invalid credentials');
      when(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tSignInParams);

      // assert
      expect(result, const Left<Failure, User>(tFailure));
      verify(
        () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
      ).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test(
      'should return NoInternetFailure when there is no internet connection',
      () async {
        // arrange
        const tFailure = NoInternetFailure();
        when(
          () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tSignInParams);

        // assert
        expect(result, const Left<Failure, User>(tFailure));
        verify(
          () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
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
          () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tSignInParams);

        // assert
        expect(result, const Left<Failure, User>(tFailure));
        verify(
          () => mockAuthRepository.signIn(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });

  group('SignInParams', () {
    test('should be equatable', () {
      // arrange
      const params1 = SignInParams(email: tEmail, password: tPassword);
      const params2 = SignInParams(email: tEmail, password: tPassword);
      const params3 = SignInParams(
        email: 'other@test.com',
        password: tPassword,
      );
      const params4 = SignInParams(email: tEmail, password: 'other123');

      // assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1, isNot(equals(params4)));
    });

    test('props should contain email and password', () {
      // arrange
      const params = SignInParams(email: tEmail, password: tPassword);

      // assert
      expect(params.props, [tEmail, tPassword]);
    });
  });
}
