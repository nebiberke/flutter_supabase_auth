import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/profile/data/models/profile_model.dart';
import 'package:flutter_supabase_auth/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mock sınıfları
class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockXFile extends Mock implements XFile {}

// Fake sınıfları
class FakeProfileModel extends Fake implements ProfileModel {}

class FakeProfileEntity extends Fake implements ProfileEntity {}

class FakeXFile extends Fake implements XFile {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockXFile mockXFile;

  setUpAll(() {
    registerFallbackValue(FakeProfileModel());
    registerFallbackValue(FakeProfileEntity());
    registerFallbackValue(FakeXFile());
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockXFile = MockXFile();
    repository = ProfileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('ProfileRepositoryImpl', () {
    const tUserId = 'test-user-id';
    const tImageUrl = 'https://example.com/image.jpg';

    const tProfileModel = ProfileModel(
      id: tUserId,
      fullName: 'Test User',
      username: 'testuser',
      email: 'test@example.com',
      avatarUrl: tImageUrl,
    );

    final tProfileEntity = tProfileModel.toEntity();

    group('getProfileWithId', () {
      test(
        'internet bağlantısı varken başarılı getProfile Right(ProfileEntity) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getProfileWithId(any()),
          ).thenAnswer((_) async => tProfileModel);

          // Act
          final result = await repository.getProfileWithId(tUserId);

          // Assert
          expect(result, equals(Right<Failure, ProfileEntity>(tProfileEntity)));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(
            () => mockRemoteDataSource.getProfileWithId(tUserId),
          ).called(1);
        },
      );

      test(
        'internet bağlantısı yokken Left(NoInternetFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.getProfileWithId(tUserId);

          // Assert
          expect(
            result,
            equals(
              const Left<NoInternetFailure, ProfileEntity>(NoInternetFailure()),
            ),
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyNever(() => mockRemoteDataSource.getProfileWithId(any()));
        },
      );

      test(
        'PostgrestException yakalandığında Left(DatabaseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getProfileWithId(any()),
          ).thenThrow(const PostgrestException(message: 'Database error'));

          // Act
          final result = await repository.getProfileWithId(tUserId);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<DatabaseFailure>()),
            (profile) => fail('Expected failure'),
          );
        },
      );

      test(
        'generic Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getProfileWithId(any()),
          ).thenThrow(Exception('Unknown error'));

          // Act
          final result = await repository.getProfileWithId(tUserId);

          // Assert
          expect(
            result,
            equals(const Left<UnknownFailure, ProfileEntity>(UnknownFailure())),
          );
        },
      );
    });

    group('updateProfile', () {
      test(
        'internet bağlantısı varken başarılı updateProfile Right(Unit) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.updateProfile(any()),
          ).thenAnswer((_) async {});

          // Act
          final result = await repository.updateProfile(tProfileEntity);

          // Assert
          expect(result, equals(const Right<Failure, Unit>(unit)));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockRemoteDataSource.updateProfile(any())).called(1);
        },
      );

      test(
        'internet bağlantısı yokken Left(NoInternetFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.updateProfile(tProfileEntity);

          // Assert
          expect(
            result,
            equals(const Left<NoInternetFailure, Unit>(NoInternetFailure())),
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyNever(() => mockRemoteDataSource.updateProfile(any()));
        },
      );

      test(
        'AuthException yakalandığında Left(AuthFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.updateProfile(any()),
          ).thenThrow(const AuthException('Auth error', code: 'auth_error'));

          // Act
          final result = await repository.updateProfile(tProfileEntity);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<AuthFailure>()),
            (unit) => fail('Expected failure'),
          );
        },
      );

      test(
        'NullResponseException yakalandığında Left(NullResponseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.updateProfile(any()),
          ).thenThrow(NullResponseException());

          // Act
          final result = await repository.updateProfile(tProfileEntity);

          // Assert
          expect(
            result,
            equals(
              const Left<NullResponseFailure, Unit>(NullResponseFailure()),
            ),
          );
        },
      );

      test(
        'PostgrestException yakalandığında Left(DatabaseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.updateProfile(any()),
          ).thenThrow(const PostgrestException(message: 'Database error'));

          // Act
          final result = await repository.updateProfile(tProfileEntity);

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<DatabaseFailure>()),
            (unit) => fail('Expected failure'),
          );
        },
      );

      test(
        'generic Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.updateProfile(any()),
          ).thenThrow(Exception('Unknown error'));

          // Act
          final result = await repository.updateProfile(tProfileEntity);

          // Assert
          expect(
            result,
            equals(const Left<UnknownFailure, Unit>(UnknownFailure())),
          );
        },
      );
    });

    group('uploadProfilePhoto', () {
      test(
        'internet bağlantısı varken başarılı uploadPhoto Right(String) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.uploadProfilePhoto(any(), any()),
          ).thenAnswer((_) async => tImageUrl);

          // Act
          final result = await repository.uploadProfilePhoto(
            mockXFile,
            tUserId,
          );

          // Assert
          expect(result, equals(const Right<Failure, String>(tImageUrl)));
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(
            () => mockRemoteDataSource.uploadProfilePhoto(mockXFile, tUserId),
          ).called(1);
        },
      );

      test(
        'internet bağlantısı yokken Left(NoInternetFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.uploadProfilePhoto(
            mockXFile,
            tUserId,
          );

          // Assert
          expect(
            result,
            equals(const Left<NoInternetFailure, String>(NoInternetFailure())),
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyNever(
            () => mockRemoteDataSource.uploadProfilePhoto(any(), any()),
          );
        },
      );

      test(
        'StorageException yakalandığında Left(DatabaseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.uploadProfilePhoto(any(), any()),
          ).thenThrow(const StorageException('Storage error'));

          // Act
          final result = await repository.uploadProfilePhoto(
            mockXFile,
            tUserId,
          );

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<DatabaseFailure>()),
            (url) => fail('Expected failure'),
          );
        },
      );

      test(
        'generic Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.uploadProfilePhoto(any(), any()),
          ).thenThrow(Exception('Unknown error'));

          // Act
          final result = await repository.uploadProfilePhoto(
            mockXFile,
            tUserId,
          );

          // Assert
          expect(
            result,
            equals(const Left<UnknownFailure, String>(UnknownFailure())),
          );
        },
      );
    });

    group('getAllProfiles', () {
      final tProfileList = [tProfileModel];

      test(
        'internet bağlantısı varken başarılı getAllProfiles Right(List<ProfileEntity>) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getAllProfiles(),
          ).thenAnswer((_) async => tProfileList);

          // Act
          final result = await repository.getAllProfiles();

          // Assert
          result.fold(
            (failure) => fail('Expected success, got failure: $failure'),
            (profiles) {
              expect(profiles, hasLength(1));
              expect(profiles.first.id, equals(tUserId));
              expect(profiles.first.email, equals('test@example.com'));
              expect(profiles.first.fullName, equals('Test User'));
              expect(profiles.first.username, equals('testuser'));
              expect(profiles.first.avatarUrl, equals(tImageUrl));
            },
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verify(() => mockRemoteDataSource.getAllProfiles()).called(1);
        },
      );

      test(
        'internet bağlantısı yokken Left(NoInternetFailure) döndürmeli',
        () async {
          // Arrange
          when(
            () => mockNetworkInfo.isConnected,
          ).thenAnswer((_) async => false);

          // Act
          final result = await repository.getAllProfiles();

          // Assert
          expect(
            result,
            equals(
              const Left<NoInternetFailure, List<ProfileEntity>>(
                NoInternetFailure(),
              ),
            ),
          );
          verify(() => mockNetworkInfo.isConnected).called(1);
          verifyNever(() => mockRemoteDataSource.getAllProfiles());
        },
      );

      test(
        'PostgrestException yakalandığında Left(DatabaseFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getAllProfiles(),
          ).thenThrow(const PostgrestException(message: 'Database error'));

          // Act
          final result = await repository.getAllProfiles();

          // Assert
          expect(result.isLeft(), isTrue);
          result.fold(
            (failure) => expect(failure, isA<DatabaseFailure>()),
            (profiles) => fail('Expected failure'),
          );
        },
      );

      test(
        'generic Exception yakalandığında Left(UnknownFailure) döndürmeli',
        () async {
          // Arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            () => mockRemoteDataSource.getAllProfiles(),
          ).thenThrow(Exception('Unknown error'));

          // Act
          final result = await repository.getAllProfiles();

          // Assert
          expect(
            result,
            equals(
              const Left<UnknownFailure, List<ProfileEntity>>(UnknownFailure()),
            ),
          );
        },
      );
    });

    group('watchProfileState', () {
      test('internet bağlantısı varken stream düzgün çalışmalı', () async {
        // Arrange
        final profileStream = Stream.value(tProfileModel);
        final connectivityStream = BehaviorSubject<bool>.seeded(true);

        when(
          () => mockRemoteDataSource.watchProfileState(any()),
        ).thenAnswer((_) => profileStream);
        when(
          () => mockNetworkInfo.onConnectivityChanged,
        ).thenAnswer((_) => connectivityStream.stream);

        // Act
        final resultStream = repository.watchProfileState(tUserId);

        // Assert
        await expectLater(
          resultStream,
          emits(Right<Failure, ProfileEntity?>(tProfileEntity)),
        );

        verify(() => mockRemoteDataSource.watchProfileState(tUserId)).called(1);
      });

      test(
        "internet bağlantısı yokken Left(NoInternetFailure) stream'i döndürmeli",
        () async {
          // Arrange
          final profileStream = Stream.value(tProfileModel);
          final connectivityStream = BehaviorSubject<bool>.seeded(false);

          when(
            () => mockRemoteDataSource.watchProfileState(any()),
          ).thenAnswer((_) => profileStream);
          when(
            () => mockNetworkInfo.onConnectivityChanged,
          ).thenAnswer((_) => connectivityStream.stream);

          // Act
          final resultStream = repository.watchProfileState(tUserId);

          // Assert
          await expectLater(
            resultStream,
            emits(
              const Left<NoInternetFailure, ProfileEntity?>(
                NoInternetFailure(),
              ),
            ),
          );
        },
      );
    });
  });
}
