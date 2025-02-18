import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_delete_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late UCDeleteProfile usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UCDeleteProfile(repository: mockRepository);
  });

  test(
    'should delete profile through the repository',
    () async {
      // arrange
      when(() => mockRepository.deleteProfile())
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(() => mockRepository.deleteProfile());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(() => mockRepository.deleteProfile())
          .thenAnswer((_) async => const Left(NoInternetFailure()));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(
        result,
        equals(const Left<Failure, Unit>(NoInternetFailure())),
      );
      verify(() => mockRepository.deleteProfile());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return AuthFailure when user is not authenticated',
    () async {
      // arrange
      when(() => mockRepository.deleteProfile())
          .thenAnswer((_) async => const Left(AuthFailure()));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(
        result,
        equals(const Left<Failure, Unit>(AuthFailure())),
      );
      verify(() => mockRepository.deleteProfile());
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
