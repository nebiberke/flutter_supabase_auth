import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock sınıfları
class MockProfileRepository extends Mock implements ProfileRepository {}

// Fake sınıfları
class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  late UCGetProfileWithId useCase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeProfileEntity());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UCGetProfileWithId(repository: mockRepository);
  });

  group('UCGetProfileWithId', () {
    const tUserId = 'test-user-id';
    const tProfile = ProfileEntity(
      id: tUserId,
      email: 'test@example.com',
      fullName: 'Test User',
      username: 'testuser',
      avatarUrl: 'https://example.com/avatar.jpg',
    );

    const tParams = GetProfileWithIdParams(userId: tUserId);

    test(
      "repository'den başarılı sonuç alınca Right(ProfileEntity) döndürmeli",
      () async {
        // Arrange
        when(
          () => mockRepository.getProfileWithId(any()),
        ).thenAnswer((_) async => const Right(tProfile));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Right<Failure, ProfileEntity>(tProfile)));
        verify(() => mockRepository.getProfileWithId(tUserId)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      const tFailure = DatabaseFailure();
      when(
        () => mockRepository.getProfileWithId(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(
        result,
        equals(const Left<DatabaseFailure, ProfileEntity>(tFailure)),
      );
      verify(() => mockRepository.getProfileWithId(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("doğru userId parametresiyle repository'yi çağırmalı", () async {
      // Arrange
      when(
        () => mockRepository.getProfileWithId(any()),
      ).thenAnswer((_) async => const Right(tProfile));

      // Act
      await useCase(tParams);

      // Assert
      verify(() => mockRepository.getProfileWithId(tUserId)).called(1);
    });

    test('GetProfileWithIdParams eşitlik karşılaştırmasını doğru yapmalı', () {
      // Arrange
      const params1 = GetProfileWithIdParams(userId: 'user1');
      const params2 = GetProfileWithIdParams(userId: 'user1');
      const params3 = GetProfileWithIdParams(userId: 'user2');

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
      expect(params1.props, equals(['user1']));
    });
  });
}
