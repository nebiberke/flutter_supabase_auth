import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_upload_profile_photo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockXFile extends Mock implements XFile {}

class FakeXFile extends Fake implements XFile {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeXFile());
  });

  late UCUploadProfilePhoto usecase;
  late MockProfileRepository mockRepository;
  late MockXFile mockXFile;

  setUp(() {
    mockRepository = MockProfileRepository();
    mockXFile = MockXFile();
    usecase = UCUploadProfilePhoto(repository: mockRepository);
  });

  const tImageUrl = 'https://example.com/image.jpg';
  late final tParams = UploadProfilePhotoParams(imageFile: mockXFile);

  test(
    'should upload profile photo through the repository',
    () async {
      // arrange
      when(() => mockRepository.uploadProfilePhoto(any<XFile>()))
          .thenAnswer((_) async => const Right(tImageUrl));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, equals(const Right<Failure, String>(tImageUrl)));
      verify(() => mockRepository.uploadProfilePhoto(any<XFile>())).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return NoInternetFailure when there is no internet connection',
    () async {
      // arrange
      when(() => mockRepository.uploadProfilePhoto(any<XFile>()))
          .thenAnswer((_) async => const Left(NoInternetFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, String>(NoInternetFailure())),
      );
      verify(() => mockRepository.uploadProfilePhoto(any<XFile>())).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return DatabaseFailure when storage operation fails',
    () async {
      // arrange
      when(() => mockRepository.uploadProfilePhoto(any<XFile>()))
          .thenAnswer((_) async => const Left(DatabaseFailure()));

      // act
      final result = await usecase(tParams);

      // assert
      expect(
        result,
        equals(const Left<Failure, String>(DatabaseFailure())),
      );
      verify(() => mockRepository.uploadProfilePhoto(any<XFile>())).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
