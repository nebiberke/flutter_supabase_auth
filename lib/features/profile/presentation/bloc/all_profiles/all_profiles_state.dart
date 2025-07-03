import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_profiles_state.freezed.dart';

@freezed
abstract class AllProfilesState with _$AllProfilesState {
  const factory AllProfilesState({
    @Default(BlocStatus.initial) BlocStatus status,
    @Default(<ProfileEntity>[]) List<ProfileEntity> profiles,
    Failure? failure,
  }) = _AllProfilesState;
}
