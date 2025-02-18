import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getCurrentProfile();
  Future<Either<Failure, ProfileEntity>> getProfileWithId(String id);
  Future<Either<Failure, Unit>> deleteProfile();
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, String>> uploadProfilePhoto(XFile imageFile);
  Stream<Either<Failure, ProfileEntity?>> get profileStateChanges;
}
