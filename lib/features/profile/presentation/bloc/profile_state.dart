import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/enums/bloc_status.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';

class ProfileState extends Equatable {
  ProfileState({
    this.status = BlocStatus.initial,
    ProfileEntity? profile,
    this.failure,
  }) : profile = profile ?? ProfileEntity.empty();

  final BlocStatus status;
  final ProfileEntity profile;
  final Failure? failure;

  ProfileState copyWith({
    BlocStatus? status,
    ProfileEntity? profile,
    Failure? failure,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, profile, failure];
}
