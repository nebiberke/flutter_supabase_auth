import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UCSignIn usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UCSignIn(repository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  const tAuthEntity = AuthEntity(
    userId: 'test_id',
    accessToken: 'test_token',
    isTokenExpired: false,
    providers: ['email'],
  );

  const tParams = SignInParams(
    email: tEmail,
    password: tPassword,
  );

  test(
    'should sign in through the repository',
    () async {
      // arrange
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right<Failure, AuthEntity>(tAuthEntity)));
      verify(
        () => mockRepository.signIn(
          email: tEmail,
          password: tPassword,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(NoInternetFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, AuthEntity>(NoInternetFailure())),
      );
      verify(
        () => mockRepository.signIn(
          email: tEmail,
          password: tPassword,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return AuthFailure when authentication fails',
    () async {
      // arrange
      when(
        () => mockRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Left(AuthFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, AuthEntity>(AuthFailure())),
      );
      verify(
        () => mockRepository.signIn(
          email: tEmail,
          password: tPassword,
        ),
      );
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
