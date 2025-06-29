import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';

class UsersState extends Equatable {
  const UsersState({
    this.status = BlocStatus.initial,
    this.profiles = const [],
    this.failure,
    this.selectedProfile,
  });

  final BlocStatus status;
  final List<ProfileEntity> profiles;
  final Failure? failure;
  final ProfileEntity? selectedProfile;

  UsersState copyWith({
    BlocStatus? status,
    List<ProfileEntity>? profiles,
    ProfileEntity? selectedProfile,
    Failure? failure,
  }) {
    return UsersState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      selectedProfile: selectedProfile ?? this.selectedProfile,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, profiles, selectedProfile, failure];
}
