import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_all_profiles.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock sınıfları
class MockProfileRepository extends Mock implements ProfileRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UCGetAllProfiles useCase;
  late MockProfileRepository mockRepository;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockRepository = MockProfileRepository();
    mockAuthRepository = MockAuthRepository();
    useCase = UCGetAllProfiles(
      repository: mockRepository,
      authRepository: mockAuthRepository,
    );
  });

  group('UCGetAllProfiles', () {
    final tProfileList = [
      const ProfileEntity(
        id: '1',
        email: 'user1@example.com',
        fullName: 'User One',
        username: 'user1',
        avatarUrl: 'https://example.com/avatar1.jpg',
      ),
      const ProfileEntity(
        id: '2',
        email: 'user2@example.com',
        fullName: 'User Two',
        username: 'user2',
        avatarUrl: 'https://example.com/avatar2.jpg',
      ),
    ];

    test(
      "repository'den başarılı sonuç alınca Right(List<ProfileEntity>) döndürmeli",
      () async {
        // Arrange
        when(
          () => mockRepository.getAllProfiles(),
        ).thenAnswer((_) async => Right(tProfileList));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(
          result,
          equals(Right<Failure, List<ProfileEntity>>(tProfileList)),
        );
        verify(() => mockRepository.getAllProfiles()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      const tFailure = DatabaseFailure();
      when(
        () => mockRepository.getAllProfiles(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(
        result,
        equals(const Left<DatabaseFailure, List<ProfileEntity>>(tFailure)),
      );
      verify(() => mockRepository.getAllProfiles()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('boş liste döndürüldüğünde Right(empty list) döndürmeli', () async {
      // Arrange
      const emptyList = <ProfileEntity>[];
      when(
        () => mockRepository.getAllProfiles(),
      ).thenAnswer((_) async => const Right(emptyList));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(
        result,
        equals(const Right<Failure, List<ProfileEntity>>(emptyList)),
      );
      verify(() => mockRepository.getAllProfiles()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
