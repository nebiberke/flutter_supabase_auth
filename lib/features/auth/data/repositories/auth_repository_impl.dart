import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.signIn(
          email: email,
          password: password,
        );
        return Right(user);
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on signIn: ${e.message} (Code: ${e.code})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on NullResponseException catch (_) {
        return const Left(NullResponseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError('Exception on signIn', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.signUp(
          email: email,
          password: password,
          fullName: fullName,
          username: username,
        );
        return Right(user);
      } on AuthException catch (e) {
        LoggerUtils().logError(
          'AuthException on signUp: ${e.message} (Code: ${e.statusCode})',
        );
        return Left(AuthFailure.fromCode(e.code));
      } on NullResponseException catch (_) {
        return const Left(NullResponseFailure());
      } on Exception catch (e, stackTrace) {
        LoggerUtils().logFatalError('Exception on signUp', stackTrace);
        return const Left(UnknownFailure());
      }
    } else {
      return const Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } on Exception catch (e, stackTrace) {
      LoggerUtils().logFatalError('Exception on signOut', stackTrace);
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.getCurrentUser();
      return Right(user);
    } on Exception catch (e, stackTrace) {
      LoggerUtils().logFatalError('Exception on getCurrentUser', stackTrace);
      return const Left(UnknownFailure());
    }
  }
}
