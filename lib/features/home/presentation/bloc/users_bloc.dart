import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/home/presentation/bloc/users_event.dart';
import 'package:flutter_supabase_auth/features/home/presentation/bloc/users_state.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_all_profiles.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_user_id.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
    required UCGetAllProfiles getAllProfiles,
    required UCGetProfileWithId getProfileWithId,
  }) : _getAllProfiles = getAllProfiles,
       _getProfileWithId = getProfileWithId,
       super(const UsersState()) {
    on<GetAllProfilesEvent>(_onGetAllProfiles);
    on<GetProfileWithIdEvent>(_onGetProfileWithId);
  }

  final UCGetAllProfiles _getAllProfiles;
  final UCGetProfileWithId _getProfileWithId;

  Future<void> _onGetAllProfiles(
    GetAllProfilesEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrProfiles = await _getAllProfiles(NoParams());

    failureOrProfiles.fold(
      (failure) =>
          emit(state.copyWith(status: BlocStatus.error, failure: failure)),
      (profiles) {
        final currentUserId = event.currentUserId;
        final filteredProfiles = profiles
            .where((profile) => profile.id != currentUserId)
            .toList();

        emit(
          state.copyWith(status: BlocStatus.loaded, profiles: filteredProfiles),
        );
      },
    );
  }

  Future<void> _onGetProfileWithId(
    GetProfileWithIdEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrProfile = await _getProfileWithId(
      GetProfileWithIdParams(userId: event.userId),
    );

    failureOrProfile.fold(
      (failure) =>
          emit(state.copyWith(status: BlocStatus.error, failure: failure)),
      (profile) => emit(
        state.copyWith(status: BlocStatus.loaded, selectedProfile: profile),
      ),
    );
  }
}
