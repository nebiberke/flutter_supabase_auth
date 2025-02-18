import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_current_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late UCGetCurrentProfile usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UCGetCurrentProfile(repository: mockRepository);
  });

  const tProfile = ProfileEntity(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  test(
    'should get current profile from the repository',
    () async {
      // arrange
      when(() => mockRepository.getCurrentProfile())
          .thenAnswer((_) async => const Right(tProfile));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right<Failure, ProfileEntity>(tProfile)));
      verify(() => mockRepository.getCurrentProfile());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(() => mockRepository.getCurrentProfile())
          .thenAnswer((_) async => const Left(NoInternetFailure()));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(
        result,
        equals(const Left<Failure, ProfileEntity>(NoInternetFailure())),
      );
      verify(() => mockRepository.getCurrentProfile());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
