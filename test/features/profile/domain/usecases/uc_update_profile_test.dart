import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_update_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock sınıfları
class MockProfileRepository extends Mock implements ProfileRepository {}

// Fake sınıfları
class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  late UCUpdateProfile useCase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeProfileEntity());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UCUpdateProfile(repository: mockRepository);
  });

  group('UCUpdateProfile', () {
    const tProfile = ProfileEntity(
      id: 'test-user-id',
      email: 'updated@example.com',
      fullName: 'Updated User',
      username: 'updateduser',
      avatarUrl: 'https://example.com/updated-avatar.jpg',
    );

    const tParams = UpdateProfileParams(profile: tProfile);

    test(
      "repository'den başarılı sonuç alınca Right(Unit) döndürmeli",
      () async {
        // Arrange
        when(
          () => mockRepository.updateProfile(any()),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Right<Failure, Unit>(unit)));
        verify(() => mockRepository.updateProfile(tProfile)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      const tFailure = AuthFailure('Update failed');
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, equals(const Left<AuthFailure, Unit>(tFailure)));
      verify(() => mockRepository.updateProfile(tProfile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("doğru profile parametresiyle repository'yi çağırmalı", () async {
      // Arrange
      when(
        () => mockRepository.updateProfile(any()),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await useCase(tParams);

      // Assert
      verify(() => mockRepository.updateProfile(tProfile)).called(1);
    });

    test('UpdateProfileParams eşitlik karşılaştırmasını doğru yapmalı', () {
      // Arrange
      const profile1 = ProfileEntity(
        id: '1',
        email: 'test@example.com',
        fullName: 'Test',
        username: 'test',
        avatarUrl: '',
      );
      const profile2 = ProfileEntity(
        id: '1',
        email: 'test@example.com',
        fullName: 'Test',
        username: 'test',
        avatarUrl: '',
      );
      const profile3 = ProfileEntity(
        id: '2',
        email: 'test2@example.com',
        fullName: 'Test2',
        username: 'test2',
        avatarUrl: '',
      );

      const params1 = UpdateProfileParams(profile: profile1);
      const params2 = UpdateProfileParams(profile: profile2);
      const params3 = UpdateProfileParams(profile: profile3);

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1.props, equals([profile1]));
    });
  });
}
