import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_upload_profile_photo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

// Mock sınıfları
class MockProfileRepository extends Mock implements ProfileRepository {}

class MockXFile extends Mock implements XFile {}

// Fake sınıfları
class FakeXFile extends Fake implements XFile {}

void main() {
  late UCUploadProfilePhoto useCase;
  late MockProfileRepository mockRepository;
  late MockXFile mockImageFile;

  setUpAll(() {
    registerFallbackValue(FakeXFile());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    mockImageFile = MockXFile();
    useCase = UCUploadProfilePhoto(repository: mockRepository);
  });

  group('UCUploadProfilePhoto', () {
    const tUserId = 'test-user-id';
    const tImageUrl = 'https://example.com/uploaded-image.jpg';

    test(
      "repository'den başarılı sonuç alınca Right(String) döndürmeli",
      () async {
        // Arrange
        final tParams = UploadProfilePhotoParams(
          imageFile: mockImageFile,
          userId: tUserId,
        );

        when(
          () => mockRepository.uploadProfilePhoto(any(), any()),
        ).thenAnswer((_) async => const Right(tImageUrl));

        // Act
        final result = await useCase(tParams);

        // Assert
        expect(result, equals(const Right<Failure, String>(tImageUrl)));
        verify(
          () => mockRepository.uploadProfilePhoto(mockImageFile, tUserId),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('repository hata döndürünce Left(Failure) döndürmeli', () async {
      // Arrange
      final tParams = UploadProfilePhotoParams(
        imageFile: mockImageFile,
        userId: tUserId,
      );

      const tFailure = DatabaseFailure();
      when(
        () => mockRepository.uploadProfilePhoto(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, equals(const Left<DatabaseFailure, String>(tFailure)));
      verify(
        () => mockRepository.uploadProfilePhoto(mockImageFile, tUserId),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test("doğru parametrelerle repository'yi çağırmalı", () async {
      // Arrange
      final tParams = UploadProfilePhotoParams(
        imageFile: mockImageFile,
        userId: tUserId,
      );

      when(
        () => mockRepository.uploadProfilePhoto(any(), any()),
      ).thenAnswer((_) async => const Right(tImageUrl));

      // Act
      await useCase(tParams);

      // Assert
      verify(
        () => mockRepository.uploadProfilePhoto(mockImageFile, tUserId),
      ).called(1);
    });

    test(
      'UploadProfilePhotoParams eşitlik karşılaştırmasını doğru yapmalı',
      () {
        // Arrange
        final mockFile1 = MockXFile();
        final mockFile2 = MockXFile();

        final params1 = UploadProfilePhotoParams(
          imageFile: mockFile1,
          userId: 'user1',
        );
        final params2 = UploadProfilePhotoParams(
          imageFile: mockFile1,
          userId: 'user1',
        );
        final params3 = UploadProfilePhotoParams(
          imageFile: mockFile2,
          userId: 'user2',
        );

        // Assert
        expect(params1, equals(params2));
        expect(params1, isNot(equals(params3)));
        expect(params1.props, equals([mockFile1, 'user1']));
      },
    );
  });
}
