import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock sınıfları
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UCSignOut useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = UCSignOut(repository: mockRepository);
  });

  group('UCSignOut', () {
    test(
      "repository'den başarılı sonuç alınca Right(Unit) döndürmeli",
      () async {
        // Arrange
        when(
          () => mockRepository.signOut(),
        ).thenAnswer((_) async => const Right(unit));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, equals(const Right<Failure, Unit>(unit)));
        verify(() => mockRepository.signOut()).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      const tFailure = UnknownFailure();
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, equals(const Left<UnknownFailure, Unit>(tFailure)));
      verify(() => mockRepository.signOut()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("repository'yi parametre olmadan çağırmalı", () async {
      // Arrange
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      await useCase(NoParams());

      // Assert
      verify(() => mockRepository.signOut()).called(1);
    });

    test('NoParams kullanılırken doğru şekilde çalışmalı', () async {
      // Arrange
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      final params = NoParams();

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals(const Right<Failure, Unit>(unit)));
      verify(() => mockRepository.signOut()).called(1);
    });

    test(
      'auth service unavailable durumunda Left(UnknownFailure) döndürmeli',
      () async {
        // Arrange
        const tFailure = UnknownFailure();
        when(
          () => mockRepository.signOut(),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await useCase(NoParams());

        // Assert
        expect(result, equals(const Left<UnknownFailure, Unit>(tFailure)));
      },
    );

    test('multiple sign out calls yapılabilmeli', () async {
      // Arrange
      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const Right(unit));

      // Act
      final result1 = await useCase(NoParams());
      final result2 = await useCase(NoParams());

      // Assert
      expect(result1, equals(const Right<Failure, Unit>(unit)));
      expect(result2, equals(const Right<Failure, Unit>(unit)));
      verify(() => mockRepository.signOut()).called(2);
    });
  });
}
