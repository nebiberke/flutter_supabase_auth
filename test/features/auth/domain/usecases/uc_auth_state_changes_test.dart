import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_auth_state_changes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UCAuthStateChanges usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = UCAuthStateChanges(repository: mockRepository);
  });

  const tAuthEntity = AuthEntity(
    userId: 'test_id',
    accessToken: 'test_token',
    isTokenExpired: false,
    providers: ['email'],
  );

  test(
    'should get auth state changes from the repository',
    () async {
      // arrange
      when(() => mockRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(const Right(tAuthEntity)));

      // act
      final stream = usecase(NoParams());

      // assert
      await expectLater(
        stream,
        emits(const Right<Failure, AuthEntity?>(tAuthEntity)),
      );
      verify(() => mockRepository.authStateChanges).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return AuthFailure when authentication fails',
    () async {
      // arrange
      when(() => mockRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(const Left(AuthFailure())));

      // act
      final stream = usecase(NoParams());

      // assert
      await expectLater(
        stream,
        emits(const Left<Failure, AuthEntity?>(AuthFailure())),
      );
      verify(() => mockRepository.authStateChanges).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return null when user signs out',
    () async {
      // arrange
      when(() => mockRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(const Right(null)));

      // act
      final stream = usecase(NoParams());

      // assert
      await expectLater(
        stream,
        emits(const Right<Failure, AuthEntity?>(null)),
      );
      verify(() => mockRepository.authStateChanges).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
