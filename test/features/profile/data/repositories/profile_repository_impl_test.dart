import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/profile/data/models/profile_model.dart';
import 'package:flutter_supabase_auth/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockXFile extends Mock implements XFile {}

class FakeXFile extends Fake implements XFile {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeXFile());
  });

  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockXFile mockXFile;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockXFile = MockXFile();
    repository = ProfileRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tProfileModel = ProfileModel(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  const tProfileEntity = ProfileEntity(
    id: 'test_id',
    email: 'test@example.com',
    fullName: 'Test User',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  group('getCurrentProfile', () {
    test(
      'should return ProfileEntity when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getCurrentProfile())
            .thenAnswer((_) async => tProfileModel);

        // act
        final result = await repository.getCurrentProfile();

        // assert
        expect(
          result,
          equals(const Right<Failure, ProfileEntity>(tProfileEntity)),
        );
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getCurrentProfile());
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.getCurrentProfile();

        // assert
        expect(
          result,
          equals(const Left<Failure, ProfileEntity>(NoInternetFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return AuthFailure when AuthException occurs',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getCurrentProfile())
            .thenThrow(const AuthException('Auth error'));

        // act
        final result = await repository.getCurrentProfile();

        // assert
        expect(
          result,
          equals(const Left<Failure, ProfileEntity>(AuthFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getCurrentProfile());
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('updateProfile', () {
    test(
      'should return unit when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.updateProfile(any()))
            .thenAnswer((_) async {});

        // act
        final result = await repository.updateProfile(tProfileEntity);

        // assert
        expect(result, equals(const Right<Failure, Unit>(unit)));
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.updateProfile(any()));
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.updateProfile(tProfileEntity);

        // assert
        expect(result, equals(const Left<Failure, Unit>(NoInternetFailure())));
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );
  });

  group('uploadProfilePhoto', () {
    const tImageUrl = 'https://example.com/image.jpg';

    test(
      'should return image url when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.uploadProfilePhoto(any()))
            .thenAnswer((_) async => tImageUrl);

        // act
        final result = await repository.uploadProfilePhoto(mockXFile);

        // assert
        expect(result, equals(const Right<Failure, String>(tImageUrl)));
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.uploadProfilePhoto(mockXFile));
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.uploadProfilePhoto(mockXFile);

        // assert
        expect(
          result,
          equals(const Left<Failure, String>(NoInternetFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return DatabaseFailure when StorageException occurs',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.uploadProfilePhoto(any()))
            .thenThrow(const StorageException('Storage error'));

        // act
        final result = await repository.uploadProfilePhoto(mockXFile);

        // assert
        expect(result, equals(const Left<Failure, String>(DatabaseFailure())));
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.uploadProfilePhoto(mockXFile));
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('profileStateChanges', () {
    test(
      'should return stream of ProfileEntity when the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.profileStateChanges)
            .thenAnswer((_) => Stream.value(tProfileModel));

        // act
        final stream = repository.profileStateChanges;

        // Wait for the stream to emit a value
        await expectLater(
          stream,
          emits(const Right<Failure, ProfileEntity?>(tProfileEntity)),
        );

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockRemoteDataSource.profileStateChanges).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final stream = repository.profileStateChanges;

        // Wait for the stream to emit a value
        await expectLater(
          stream,
          emits(const Left<Failure, ProfileEntity?>(NoInternetFailure())),
        );

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return AuthFailure when AuthException occurs',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.profileStateChanges)
            .thenAnswer((_) => Stream.error(const AuthException('Auth error')));

        // act
        final stream = repository.profileStateChanges;

        // Wait for the stream to emit a value
        await expectLater(
          stream,
          emits(const Left<Failure, ProfileEntity?>(AuthFailure())),
        );

        // assert
        verify(() => mockNetworkInfo.isConnected).called(1);
        verify(() => mockRemoteDataSource.profileStateChanges).called(1);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );
  });

  group('getProfileWithId', () {
    const tId = 'test_id';

    test(
      'should return ProfileEntity when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.getProfileWithId(any()))
            .thenAnswer((_) async => tProfileModel);

        // act
        final result = await repository.getProfileWithId(tId);

        // assert
        expect(
          result,
          equals(const Right<Failure, ProfileEntity>(tProfileEntity)),
        );
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.getProfileWithId(tId));
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.getProfileWithId(tId);

        // assert
        expect(
          result,
          equals(const Left<Failure, ProfileEntity>(NoInternetFailure())),
        );
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );
  });

  group('deleteProfile', () {
    test(
      'should return unit when the device is online and call is successful',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockRemoteDataSource.deleteProfile())
            .thenAnswer((_) async {});

        // act
        final result = await repository.deleteProfile();

        // assert
        expect(result, equals(const Right<Failure, Unit>(unit)));
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockRemoteDataSource.deleteProfile());
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test(
      'should return NoInternetFailure when the device is offline',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.deleteProfile();

        // assert
        expect(result, equals(const Left<Failure, Unit>(NoInternetFailure())));
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
        verifyZeroInteractions(mockRemoteDataSource);
      },
    );
  });
}
