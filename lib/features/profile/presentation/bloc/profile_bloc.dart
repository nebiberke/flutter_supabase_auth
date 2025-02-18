import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_delete_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_current_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_id.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_profile_state_changes.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_update_profile.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_upload_profile_photo.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/profile_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UCGetCurrentProfile getCurrentProfile,
    required UCGetProfileWithId getProfileWithId,
    required UCDeleteProfile deleteProfile,
    required UCUpdateProfile updateProfile,
    required UCProfileStateChanges profileStateChanges,
    required UCUploadProfilePhoto uploadProfilePhoto,
  })  : _getCurrentProfile = getCurrentProfile,
        _getProfileWithId = getProfileWithId,
        _deleteProfile = deleteProfile,
        _updateProfile = updateProfile,
        _profileStateChanges = profileStateChanges,
        _uploadProfilePhoto = uploadProfilePhoto,
        super(ProfileState()) {
    on<GetCurrentProfileEvent>(_onGetCurrentProfile);
    on<GetProfileWithIdEvent>(_onGetProfileWithId);
    on<DeleteProfileEvent>(_onDeleteProfile);
    on<ProfileStateChangesEvent>(_onGetProfileStream);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  final UCGetCurrentProfile _getCurrentProfile;
  final UCGetProfileWithId _getProfileWithId;
  final UCDeleteProfile _deleteProfile;
  final UCUpdateProfile _updateProfile;
  final UCProfileStateChanges _profileStateChanges;
  final UCUploadProfilePhoto _uploadProfilePhoto;

  Future<void> _onGetProfileStream(
    ProfileStateChangesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    return emit.onEach(
      _profileStateChanges(NoParams()),
      onData: (failureOrProfile) => failureOrProfile.fold(
        (failure) => emit(
          state.copyWith(
            status: BlocStatus.error,
            failure: failure,
          ),
        ),
        (profile) {
          return emit(
            state.copyWith(
              status: BlocStatus.loaded,
              profile: profile,
            ),
          );
        },
      ),
    );
  }

  Future<void> _onGetCurrentProfile(
    GetCurrentProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final failureOrProfile = await _getCurrentProfile(NoParams());
    failureOrProfile.fold(
      (failure) => emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: failure,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: BlocStatus.loaded,
          profile: profile,
        ),
      ),
    );
  }

  Future<void> _onGetProfileWithId(
    GetProfileWithIdEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final failureOrProfile = await _getProfileWithId(
      GetProfileWithIdParams(
        id: event.id,
      ),
    );
    failureOrProfile.fold(
      (failure) => emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: failure,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          status: BlocStatus.loaded,
          profile: profile,
        ),
      ),
    );
  }

  Future<void> _onDeleteProfile(
    DeleteProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final failureOrUnit = await _deleteProfile(NoParams());
    failureOrUnit.fold(
      (failure) => emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: BlocStatus.loaded,
        ),
      ),
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
        UploadProfilePhotoParams(imageFile: event.imageFile!),
      );

      failureOrUrl.fold(
        (failure) => emit(
          state.copyWith(
            status: BlocStatus.error,
            failure: failure,
          ),
        ),
        (url) => avatarUrl = url,
      );
    }

    final updatedProfile = (avatarUrl != event.profile.avatarUrl)
        ? event.profile.copyWith(avatarUrl: avatarUrl)
        : event.profile;

    final failureOrUnit = await _updateProfile(
      UpdateProfileParams(profile: updatedProfile),
    );

    failureOrUnit.fold(
      (failure) => emit(
        state.copyWith(
          status: BlocStatus.error,
          failure: failure,
        ),
      ),
      (_) => null,
    );
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    try {
      return ProfileState(
        status: BlocStatus.values[json['status'] as int],
        profile:
            ProfileEntity.fromJson(json['profile'] as Map<String, dynamic>),
      );
    } on Exception catch (_) {
      return ProfileState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    return {
      'status': state.status.index,
      'profile': state.profile.toJson(),
    };
  }
}
