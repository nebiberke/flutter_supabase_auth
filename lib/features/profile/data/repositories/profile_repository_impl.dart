import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/profile/data/models/profile_model.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  final ProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ProfileEntity>> getProfileWithId(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final profileModel = await _remoteDataSource.getProfileWithId(userId);
        return Right(profileModel.toEntity());
      } on PostgrestException catch (e) {
        LoggerUtils().logError(
          'PostgrestException on getProfileWithId: ${e.message} (Code: ${e.code})',
        );
        return const Left(DatabaseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError(
          'Exception on getProfileWithId',
          stackTrace,
        );
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity newProfile) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedProfile = newProfile.toModel();
        await _remoteDataSource.updateProfile(updatedProfile);
        return const Right(unit);
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on updateProfile: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on PostgrestException catch (e) {
        LoggerUtils().logError(
          'PostgrestException on updateProfile: ${e.message} (Code: ${e.code})',
        );
        return const Left(DatabaseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError('Exception on updateProfile', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Stream<Either<Failure, ProfileEntity?>> watchProfileState(String userId) {
    final remoteStream = _remoteDataSource
        .watchProfileState(userId)
        .map((model) => Right<Failure, ProfileEntity?>(model?.toEntity()))
        .handleError((Object error, StackTrace stackTrace) {
          if (error is PostgrestException) {
            LoggerUtils().logError(
              'PostgrestException on watchProfileState: ${error.message} (Code: ${error.code})',
            );
            return const Left<Failure, ProfileEntity?>(DatabaseFailure());
          } else if (error is RealtimeSubscribeException) {
            LoggerUtils().logError(
              'RealtimeSubscribeException on watchProfileState: ${error.status}',
            );
            return const Left<Failure, ProfileEntity?>(DatabaseFailure());
          }
          LoggerUtils().logFatalError('Unhandled stream error', stackTrace);
          return const Left<Failure, ProfileEntity?>(UnknownFailure());
        });

    return _networkInfo.onConnectivityChanged.switchMap((bool connected) {
      if (connected) {
        return remoteStream;
      } else {
        return Stream.value(
          const Left<Failure, ProfileEntity?>(NoInternetFailure()),
        );
      }
    });
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(
    XFile imageFile,
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final imageUrl = await _remoteDataSource.uploadProfilePhoto(
          imageFile,
          userId,
        );
        return Right(imageUrl);
      } on StorageException catch (e) {
        LoggerUtils().logError(
          'StorageException on uploadProfilePhoto: ${e.message}',
        );
        return const Left(DatabaseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError(
          'Exception on uploadProfilePhoto',
          stackTrace,
        );
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProfileEntity>>> getAllProfiles() async {
    if (await _networkInfo.isConnected) {
      try {
        final profiles = await _remoteDataSource.getAllProfiles();
        return Right(profiles.map((e) => e.toEntity()).toList());
      } on PostgrestException catch (e) {
        LoggerUtils().logError(
          'PostgrestException on getAllProfiles: ${e.message} (Code: ${e.code})',
        );
        return const Left(DatabaseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError('Exception on getAllProfiles', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }
}
