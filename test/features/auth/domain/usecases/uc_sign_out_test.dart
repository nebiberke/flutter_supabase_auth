import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UCSignOut usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UCSignOut(repository: mockRepository);
  });

  test(
    'should sign out through the repository',
    () async {
      // arrange
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(() => mockRepository.signOut());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return UnknownFailure when sign out fails',
    () async {
      // arrange
      when(() => mockRepository.signOut())
          .thenAnswer((_) async => const Left(UnknownFailure()));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(
        result,
        equals(const Left<Failure, Unit>(UnknownFailure())),
      );
      verify(() => mockRepository.signOut());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
