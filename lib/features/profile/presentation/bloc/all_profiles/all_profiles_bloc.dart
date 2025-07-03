import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/usecases/uc_get_all_profiles.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_event.dart';
import 'package:flutter_supabase_auth/features/profile/presentation/bloc/all_profiles/all_profiles_state.dart';

class AllProfilesBloc extends Bloc<AllProfilesEvent, AllProfilesState> {
  AllProfilesBloc({required UCGetAllProfiles getAllProfiles})
    : _getAllProfiles = getAllProfiles,
      super(const AllProfilesState()) {
    on<GetAllProfilesEvent>(_onGetAllProfiles);
  }

  final UCGetAllProfiles _getAllProfiles;

  Future<void> _onGetAllProfiles(
    GetAllProfilesEvent event,
    Emitter<AllProfilesState> emit,
  ) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrProfiles = await _getAllProfiles(NoParams());

    failureOrProfiles.fold(
      (failure) =>
          emit(state.copyWith(status: BlocStatus.error, failure: failure)),
      (profiles) {
        emit(state.copyWith(status: BlocStatus.loaded, profiles: profiles));
      },
    );
  }
}
