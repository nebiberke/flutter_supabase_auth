import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_profile_state_changes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late UCProfileStateChanges usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UCProfileStateChanges(repository: mockRepository);
  });

  const tProfile = ProfileEntity(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  test(
    'should get profile state changes from the repository',
    () async {
      // arrange
      when(() => mockRepository.profileStateChanges)
          .thenAnswer((_) => Stream.value(const Right(tProfile)));

      // act
      final stream = usecase(NoParams());

      // assert
      await expectLater(
        stream,
        emits(const Right<Failure, ProfileEntity?>(tProfile)),
      );
      verify(() => mockRepository.profileStateChanges).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(() => mockRepository.profileStateChanges)
          .thenAnswer((_) => Stream.value(const Left(NoInternetFailure())));

      // act
      final stream = usecase(NoParams());

      // assert
      await expectLater(
        stream,
        emits(const Left<Failure, ProfileEntity?>(NoInternetFailure())),
      );
      verify(() => mockRepository.profileStateChanges).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return null profile when user signs out',
    () async {
      // arrange
      when(() => mockRepository.profileStateChanges)
          .thenAnswer((_) => Stream.value(const Right(null)));

      // act
      final stream = usecase(NoParams());

      // assert
      await expectLater(
        stream,
        emits(const Right<Failure, ProfileEntity?>(null)),
      );
      verify(() => mockRepository.profileStateChanges).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
