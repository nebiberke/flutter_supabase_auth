import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentProfileEvent extends ProfileEvent {
  const GetCurrentProfileEvent();
}

class GetProfileWithIdEvent extends ProfileEvent {
  const GetProfileWithIdEvent({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

class DeleteProfileEvent extends ProfileEvent {
  const DeleteProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  const UpdateProfileEvent({
    required this.profile,
    this.imageFile,
  });

  final ProfileEntity profile;
  final XFile? imageFile;

  @override
  List<Object?> get props => [profile, imageFile];
}

class ProfileStateChangesEvent extends ProfileEvent {}
