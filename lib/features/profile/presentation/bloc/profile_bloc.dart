import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_user_id.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_update_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_upload_profile_photo.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_watch_profile_state.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UCGetProfileWithId getProfileWithId,
    required UCUpdateProfile updateProfile,
    required UCWatchProfileState watchProfileState,
    required UCUploadProfilePhoto uploadProfilePhoto,
  }) : _getProfileWithId = getProfileWithId,
       _updateProfile = updateProfile,
       _watchProfileState = watchProfileState,
       _uploadProfilePhoto = uploadProfilePhoto,
       super(ProfileState()) {
    on<GetProfileWithIdEvent>(_ongetProfileWithId);
    on<WatchProfileStateEvent>(_onWatchProfileState);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ProfileStreamUpdated>(_onProfileStreamUpdated);
    on<SignOutProfileEvent>(_onSignOutProfile);
  }

  final UCGetProfileWithId _getProfileWithId;
  final UCUpdateProfile _updateProfile;
  final UCWatchProfileState _watchProfileState;
  final UCUploadProfilePhoto _uploadProfilePhoto;
  StreamSubscription<Either<Failure, ProfileEntity?>>? _profileSubscription;

  Future<void> _onSignOutProfile(
    SignOutProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _profileSubscription?.cancel();
    emit(ProfileState());
  }

  Future<void> _onWatchProfileState(
    WatchProfileStateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await _profileSubscription?.cancel();
    _profileSubscription =
        _watchProfileState(
          WatchProfileStateParams(userId: event.userId),
        ).listen((failureOrProfile) {
          failureOrProfile.fold(
            (failure) {
              add(ProfileStreamUpdated(failure: failure));
            },
            (profile) {
              add(ProfileStreamUpdated(profile: profile));
            },
          );
        });
  }

  void _onProfileStreamUpdated(
    ProfileStreamUpdated event,
    Emitter<ProfileState> emit,
  ) {
    if (event.failure != null) {
      emit(state.copyWith(status: BlocStatus.error, failure: event.failure));
    } else {
      emit(state.copyWith(status: BlocStatus.loaded, profile: event.profile));
    }
  }

  Future<void> _ongetProfileWithId(
    GetProfileWithIdEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrProfile = await _getProfileWithId(
      GetProfileWithIdParams(userId: event.userId),
    );

    failureOrProfile.fold(
      (failure) =>
          emit(state.copyWith(status: BlocStatus.error, failure: failure)),
      (profile) {
        emit(state.copyWith(status: BlocStatus.loaded, profile: profile));
        add(WatchProfileStateEvent(userId: event.userId));
      },
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    String? avatarUrl = event.profile.avatarUrl;

    if (event.imageFile != null) {
      final failureOrUrl = await _uploadProfilePhoto(
        UploadProfilePhotoParams(
          imageFile: event.imageFile!,
          userId: event.profile.id,
        ),
      );

      failureOrUrl.fold(
        (failure) {
          emit(state.copyWith(status: BlocStatus.error, failure: failure));
        },
        (url) {
          avatarUrl = url;
        },
      );
    }

    final updatedProfile = (avatarUrl != event.profile.avatarUrl)
        ? event.profile.copyWith(avatarUrl: avatarUrl)
        : event.profile;

    final failureOrUnit = await _updateProfile(
      UpdateProfileParams(profile: updatedProfile),
    );

    failureOrUnit.fold(
      (failure) =>
          emit(state.copyWith(status: BlocStatus.error, failure: failure)),
      (_) {
        return emit(
          state.copyWith(status: BlocStatus.loaded, profile: updatedProfile),
        );
      },
    );
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    try {
      return ProfileState(
        status: BlocStatus.values[json['status'] as int],
        profile: ProfileEntity.fromJson(
          json['profile'] as Map<String, dynamic>,
        ),
      );
    } on Exception catch (_) {
      return ProfileState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    return {'status': state.status.index, 'profile': state.profile.toJson()};
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}
