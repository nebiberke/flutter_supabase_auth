import 'package:flutter_supabase_auth/app/theme/cubit/theme_cubit.dart';
import 'package:flutter_supabase_auth/core/network/network_info.dart';
import 'package:flutter_supabase_auth/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_get_current_user.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_up.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_supabase_auth/features/home/presentation/bloc/users_bloc.dart';
import 'package:flutter_supabase_auth/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter_supabase_auth/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_all_profiles.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_user_id.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_update_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_upload_profile_photo.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_watch_profile_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class Locator {
  /// [GetIt] instance
  static final GetIt _instance = GetIt.instance;

  /// Returns instance of [AuthBloc]
  static AuthBloc get authBloc => _instance<AuthBloc>();

  /// Returns instance of [ProfileBloc]
  static ProfileBloc get profileBloc => _instance<ProfileBloc>();

  /// Returns instance of [UsersBloc]
  static UsersBloc get usersBloc => _instance<UsersBloc>();

  /// Returns instance of [ThemeCubit]
  static ThemeCubit get themeCubit => _instance<ThemeCubit>();

  /// Returns instance of [SupabaseClient]
  static SupabaseClient get supabase => _instance<SupabaseClient>();

  /// Returns instance of [NetworkInfo]
  static NetworkInfo get networkInfo => _instance<NetworkInfo>();

  static void setupLocator({required SupabaseClient supabase}) {
    _instance
      // SupabaseClient
      ..registerLazySingleton<SupabaseClient>(() => supabase)
      // ThemeCubit
      ..registerLazySingleton(ThemeCubit.new)
      /// [Auth]
      // AuthRemoteDataSource
      ..registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(supabase: _instance<SupabaseClient>()),
      )
      // AuthRepository
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: _instance<AuthRemoteDataSource>(),
          networkInfo: _instance<NetworkInfo>(),
        ),
      )
      // UCSignIn
      ..registerFactory(() => UCSignIn(repository: _instance<AuthRepository>()))
      // UCSignUp
      ..registerFactory(() => UCSignUp(repository: _instance<AuthRepository>()))
      // UCSignOut
      ..registerFactory(
        () => UCSignOut(repository: _instance<AuthRepository>()),
      )
      // UCGetCurrentUser
      ..registerFactory(
        () => UCGetCurrentUser(repository: _instance<AuthRepository>()),
      )
      // AuthBloc
      ..registerLazySingleton(
        () => AuthBloc(
          signIn: _instance<UCSignIn>(),
          signUp: _instance<UCSignUp>(),
          signOut: _instance<UCSignOut>(),
          getCurrentUser: _instance<UCGetCurrentUser>(),
        ),
      )
      /// [Profile]
      // ProfileRemoteDataSource
      ..registerLazySingleton<ProfileRemoteDataSource>(
        () =>
            ProfileRemoteDataSourceImpl(supabase: _instance<SupabaseClient>()),
      )
      // ProfileRepository
      ..registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
          remoteDataSource: _instance<ProfileRemoteDataSource>(),
          networkInfo: _instance<NetworkInfo>(),
        ),
      )
      // UCGetProfileWithId
      ..registerFactory(
        () => UCGetProfileWithId(repository: _instance<ProfileRepository>()),
      )
      // UCWatchProfileState
      ..registerFactory(
        () => UCWatchProfileState(repository: _instance<ProfileRepository>()),
      )
      // UCUpdateProfile
      ..registerFactory(
        () => UCUpdateProfile(repository: _instance<ProfileRepository>()),
      )
      // UCUploadProfilePhoto
      ..registerFactory(
        () => UCUploadProfilePhoto(repository: _instance<ProfileRepository>()),
      )
      // UCGetAllProfiles
      ..registerFactory(
        () => UCGetAllProfiles(repository: _instance<ProfileRepository>()),
      )
      // ProfileBloc
      ..registerLazySingleton(
        () => ProfileBloc(
          getProfileWithId: _instance<UCGetProfileWithId>(),
          watchProfileState: _instance<UCWatchProfileState>(),
          updateProfile: _instance<UCUpdateProfile>(),
          uploadProfilePhoto: _instance<UCUploadProfilePhoto>(),
        ),
      )
      // UsersBloc
      ..registerLazySingleton(
        () => UsersBloc(
          getAllProfiles: _instance<UCGetAllProfiles>(),
          getProfileWithId: _instance<UCGetProfileWithId>(),
        ),
      )
      /// [Core]
      // NetworkInfo
      ..registerLazySingleton(InternetConnection.createInstance)
      ..registerLazySingleton<NetworkInfo>(
        () =>
            NetworkInfoImpl(connectionChecker: _instance<InternetConnection>()),
      );
  }
}
