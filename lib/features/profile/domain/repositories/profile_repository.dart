import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfileWithId(String userId);
  Future<Either<Failure, Unit>> updateProfile(ProfileEntity newProfile);
  Future<Either<Failure, String>> uploadProfilePhoto(
    XFile imageFile,
    String userId,
  );
  Stream<Either<Failure, ProfileEntity?>> watchProfileState(String userId);
  Future<Either<Failure, List<ProfileEntity>>> getAllProfiles();
}
