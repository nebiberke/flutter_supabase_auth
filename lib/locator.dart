import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_auth_state_changes.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_up.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_delete_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_current_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_id.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_profile_state_changes.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_update_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_upload_profile_photo.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class Locator {
  /// [GetIt] instance
  static final _instance = GetIt.instance;

  /// Returns instance of [AuthBloc]
  static AuthBloc get authBloc => _instance<AuthBloc>();

  /// Returns instance of [ProfileBloc]
  static ProfileBloc get profileBloc => _instance<ProfileBloc>();

  /// Returns instance of [SupabaseClient]
  static SupabaseClient get supabase => _instance<SupabaseClient>();

  /// Returns instance of [NetworkInfo]
  static NetworkInfo get networkInfo => _instance<NetworkInfo>();

  static void setupLocator({required SupabaseClient supabase}) {
    _instance

      // SupabaseClient
      ..registerLazySingleton<SupabaseClient>(() => supabase)

      /// [Auth]
      // AuthRemoteDataSource
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supabase: _instance()),
      )

      // AuthRepository
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: _instance(),
          networkInfo: _instance(),
        ),
      )

      // UCSignIn
      ..registerFactory(
        () => UCSignIn(repository: _instance()),
      )

      // UCSignUp
      ..registerFactory(
        () => UCSignUp(repository: _instance()),
      )

      // UCSignOut
      ..registerFactory(
        () => UCSignOut(repository: _instance()),
      )

      // UCAuthStateChanges
      ..registerFactory(
        () => UCAuthStateChanges(repository: _instance()),
      )

      // AuthBloc
      ..registerLazySingleton(
        () => AuthBloc(
          signIn: _instance(),
          signUp: _instance(),
          signOut: _instance(),
          authStateChanges: _instance(),
        ),
      )

      /// [Profile]
      // ProfileRemoteDataSource
      ..registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSourceImpl(supabase: _instance()),
      )

      // ProfileRepository
      ..registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
          remoteDataSource: _instance(),
          networkInfo: _instance(),
        ),
      )

      // UCGetProfileWithId
      ..registerFactory(
        () => UCGetProfileWithId(repository: _instance()),
      )

      // UCGetCurrentProfile
      ..registerFactory(
        () => UCGetCurrentProfile(repository: _instance()),
      )

      // UCDeleteProfile
      ..registerFactory(
        () => UCDeleteProfile(repository: _instance()),
      )

      // UCProfileStateChanges
      ..registerFactory(
        () => UCProfileStateChanges(repository: _instance()),
      )

      // UCUpdateProfile
      ..registerFactory(
        () => UCUpdateProfile(repository: _instance()),
      )

      // UCUploadProfilePhoto
      ..registerFactory(
        () => UCUploadProfilePhoto(repository: _instance()),
      )

      // ProfileBloc
      ..registerLazySingleton(
        () => ProfileBloc(
          getCurrentProfile: _instance(),
          getProfileWithId: _instance(),
          deleteProfile: _instance(),
          updateProfile: _instance(),
          profileStateChanges: _instance(),
          uploadProfilePhoto: _instance(),
        ),
      )

      /// [Core]
      // NetworkInfo
      ..registerLazySingleton(
        InternetConnection.createInstance,
      )
      ..registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(connectionChecker: _instance()),
      );
  }
}
