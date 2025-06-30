import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileWithIdEvent extends ProfileEvent {
  const GetProfileWithIdEvent({required this.userId});
  final String userId;

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  const UpdateProfileEvent({required this.profile, this.imageFile});

  final ProfileEntity profile;
  final XFile? imageFile;

  @override
  List<Object?> get props => [profile, imageFile];
}

class WatchProfileStateEvent extends ProfileEvent {
  const WatchProfileStateEvent({required this.userId});
  final String userId;

  @override
  List<Object?> get props => [userId];
}

class SignOutProfileEvent extends ProfileEvent {
  const SignOutProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStreamUpdated extends ProfileEvent {
  const ProfileStreamUpdated({this.profile, this.failure});
  final ProfileEntity? profile;
  final Failure? failure;

  @override
  List<Object?> get props => [profile, failure];
}
