import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock sınıfları
class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late UCGetCurrentUser useCase;
  late MockAuthRepository mockRepository;
  late MockUser mockUser;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockUser = MockUser();
    useCase = UCGetCurrentUser(repository: mockRepository);
  });

  group('UCGetCurrentUser', () {
    test("repository'den user varsa Right(User) döndürmeli", () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, equals(Right<Failure, User?>(mockUser)));
      verify(() => mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("repository'den user yoksa Right(null) döndürmeli", () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(null);

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, equals(const Right<Failure, User?>(null)));
      verify(() => mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("repository'yi parametre olmadan çağırmalı", () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);

      // Act
      await useCase(NoParams());

      // Assert
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('NoParams kullanılırken doğru şekilde çalışmalı', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);

      final params = NoParams();

      // Act
      final result = await useCase(params);

      // Assert
      expect(result, equals(Right<Failure, User?>(mockUser)));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('multiple calls yapılabilmeli', () async {
      // Arrange
      when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);

      // Act
      final result1 = await useCase(NoParams());
      final result2 = await useCase(NoParams());

      // Assert
      expect(result1, equals(Right<Failure, User?>(mockUser)));
      expect(result2, equals(Right<Failure, User?>(mockUser)));
      verify(() => mockRepository.getCurrentUser()).called(2);
    });

    test(
      'authenticated user ile null user arasında geçiş yapabilmeli',
      () async {
        // Arrange & Act & Assert - İlk çağrıda user var
        when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);
        final result1 = await useCase(NoParams());
        expect(result1, equals(Right<Failure, User?>(mockUser)));

        // Arrange & Act & Assert - İkinci çağrıda user yok
        when(() => mockRepository.getCurrentUser()).thenReturn(null);
        final result2 = await useCase(NoParams());
        expect(result2, equals(const Right<Failure, User?>(null)));

        verify(() => mockRepository.getCurrentUser()).called(2);
      },
    );

    test('user state değişikliklerini doğru şekilde handle etmeli', () async {
      // Arrange - İlk durum: kullanıcı yok
      when(() => mockRepository.getCurrentUser()).thenReturn(null);

      // Act & Assert - Kullanıcı yok
      final result1 = await useCase(NoParams());
      expect(result1, equals(const Right<Failure, User?>(null)));

      // Arrange - İkinci durum: kullanıcı giriş yaptı
      when(() => mockRepository.getCurrentUser()).thenReturn(mockUser);

      // Act & Assert - Kullanıcı var
      final result2 = await useCase(NoParams());
      expect(result2, equals(Right<Failure, User?>(mockUser)));

      verify(() => mockRepository.getCurrentUser()).called(2);
    });
  });
}
