import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/profile/data/models/profile_model.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  final ProfileRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, Unit>> deleteProfile() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteProfile();
        return const Right(unit);
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on deleteProfile: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on NullResponseException catch (_) {
        return const Left(NullResponseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError('Exception on deleteProfile', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getCurrentProfile() async {
    if (await _networkInfo.isConnected) {
      try {
        final profileModel = await _remoteDataSource.getCurrentProfile();
        return Right(profileModel.toEntity());
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on getCurrentProfile: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on NullResponseException catch (_) {
        return const Left(NullResponseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils()
            .logFatalError('Exception on getCurrentProfile', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getProfileWithId(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final profileModel = await _remoteDataSource.getProfileWithId(id);
        return Right(profileModel.toEntity());
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on getProfileWithId: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on NullResponseException catch (_) {
        return const Left(NullResponseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils()
            .logFatalError('Exception on getProfileWithId', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity profile) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedProfile = ProfileModel.fromEntity(profile);
        await _remoteDataSource.updateProfile(updatedProfile);
        return const Right(unit);
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on updateProfile: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on NullResponseException catch (_) {
        return const Left(NullResponseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError('Exception on updateProfile', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Stream<Either<Failure, ProfileEntity?>> get profileStateChanges async* {
    if (await _networkInfo.isConnected) {
      try {
        await for (final profileModel
            in _remoteDataSource.profileStateChanges) {
          yield Right(profileModel?.toEntity());
        }
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on profileStateChanges: ${e.message} (Code: ${e.statusCode})',
        );
        yield Left(AuthFailure.fromCode(e.code));
      } on Exception catch (e, stackTrace) {
        LoggerUtils()
            .logFatalError('Exception on profileStateChanges', stackTrace);
        yield const Left(UnknownFailure());
      }
    } else {
      yield const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(XFile imageFile) async {
    if (await _networkInfo.isConnected) {
      try {
        final imageUrl = await _remoteDataSource.uploadProfilePhoto(imageFile);
        return Right(imageUrl);
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on uploadProfilePhoto: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on StorageException catch (e) {
        LoggerUtils().logError(
          'StorageException on uploadProfilePhoto: ${e.message}',
        );
        return const Left(DatabaseFailure());
      } on DatabaseException catch (_) {
        return const Left(DatabaseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils()
            .logFatalError('Exception on uploadProfilePhoto', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }
}
