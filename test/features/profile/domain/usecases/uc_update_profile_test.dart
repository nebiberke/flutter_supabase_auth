import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_update_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProfileEntity());
  });

  late UCUpdateProfile usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UCUpdateProfile(repository: mockRepository);
  });

  const tProfile = ProfileEntity(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  const tParams = UpdateProfileParams(profile: tProfile);

  test(
    'should update profile through the repository',
    () async {
      // arrange
      when(() => mockRepository.updateProfile(any()))
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(() => mockRepository.updateProfile(tProfile));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(() => mockRepository.updateProfile(any()))
          .thenAnswer((_) async => const Left(NoInternetFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, Unit>(NoInternetFailure())),
      );
      verify(() => mockRepository.updateProfile(tProfile));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
