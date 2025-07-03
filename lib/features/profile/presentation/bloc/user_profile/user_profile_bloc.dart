import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_profile_with_user_id.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/user_profile/user_profile_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/user_profile/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({required UCGetProfileWithId getProfileWithId})
    : _getProfileWithId = getProfileWithId,
      super(const UserProfileState()) {
    on<GetProfileWithIdEvent>(_onGetProfileWithId);
  }

  final UCGetProfileWithId _getProfileWithId;

  Future<void> _onGetProfileWithId(
    GetProfileWithIdEvent event,
    Emitter<UserProfileState> emit,
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
