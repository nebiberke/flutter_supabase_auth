import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late UCGetCurrentUser useCase;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();
    useCase = UCGetCurrentUser(repository: mockAuthRepository);
  });

  group('UCGetCurrentUser', () {
    test(
      'should get current user from the repository when user exists',
      () async {
        // arrange
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => Right(mockUser));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, Right<Failure, User>(mockUser));
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return null from the repository when no user is logged in',
      () async {
        // arrange
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Right(null));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Right<Failure, User?>(null));
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return AuthFailure when repository returns auth failure',
      () async {
        // arrange
        const tFailure = AuthFailure('Failed to get current user');
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left<Failure, User?>(tFailure));
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return NoInternetFailure when repository returns no internet failure',
      () async {
        // arrange
        const tFailure = NoInternetFailure();
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left<Failure, User?>(tFailure));
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return UnknownFailure when repository returns unknown failure',
      () async {
        // arrange
        const tFailure = UnknownFailure();
        when(
          () => mockAuthRepository.getCurrentUser(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left<Failure, User?>(tFailure));
        verify(() => mockAuthRepository.getCurrentUser()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
