import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UCSignOut useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UCSignOut(repository: mockAuthRepository);
  });

  group('UCSignOut', () {
    test('should return Unit when sign out is successful', () async {
      // arrange
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, const Right<Failure, Unit>(unit));
      verify(() => mockAuthRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return AuthFailure when sign out fails', () async {
      // arrange
      const tFailure = AuthFailure('Failed to sign out');
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, const Left<Failure, Unit>(tFailure));
      verify(() => mockAuthRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test(
      'should return NoInternetFailure when there is no internet connection',
      () async {
        // arrange
        const tFailure = NoInternetFailure();
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left<Failure, Unit>(tFailure));
        verify(() => mockAuthRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return UnknownFailure when an unexpected error occurs',
      () async {
        // arrange
        const tFailure = UnknownFailure();
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(NoParams());

        // assert
        expect(result, const Left<Failure, Unit>(tFailure));
        verify(() => mockAuthRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test('should call repository signOut method exactly once', () async {
      // arrange
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // act
      await useCase(NoParams());

      // assert
      verify(() => mockAuthRepository.signOut()).called(1);
    });
  });
}
