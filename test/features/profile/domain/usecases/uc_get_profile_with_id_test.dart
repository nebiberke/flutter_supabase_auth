import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late UCGetProfileWithId usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UCGetProfileWithId(repository: mockRepository);
  });

  const tProfile = ProfileEntity(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  const tParams = GetProfileWithIdParams(id: 'test_id');

  test(
    'should get profile with id from the repository',
    () async {
      // arrange
      when(() => mockRepository.getProfileWithId(any()))
          .thenAnswer((_) async => const Right(tProfile));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right<Failure, ProfileEntity>(tProfile)));
      verify(() => mockRepository.getProfileWithId(tParams.id));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(() => mockRepository.getProfileWithId(any()))
          .thenAnswer((_) async => const Left(NoInternetFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, ProfileEntity>(NoInternetFailure())),
      );
      verify(() => mockRepository.getProfileWithId(tParams.id));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return AuthFailure when user is not found',
    () async {
      // arrange
      when(() => mockRepository.getProfileWithId(any()))
          .thenAnswer((_) async => const Left(AuthFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, ProfileEntity>(AuthFailure())),
      );
      verify(() => mockRepository.getProfileWithId(tParams.id));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return DatabaseFailure when database operation fails',
    () async {
      // arrange
      when(() => mockRepository.getProfileWithId(any()))
          .thenAnswer((_) async => const Left(DatabaseFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, ProfileEntity>(DatabaseFailure())),
      );
      verify(() => mockRepository.getProfileWithId(tParams.id));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
