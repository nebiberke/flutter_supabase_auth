import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/profile/data/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getCurrentProfile();
  Future<ProfileModel> getProfileWithId(String id);
  Stream<ProfileModel?> get profileStateChanges;
  Future<void> deleteProfile();
  Future<void> updateProfile(ProfileModel? newProfile);
  Future<String> uploadProfilePhoto(XFile imageFile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required SupabaseClient supabase,
  }) : _supabase = supabase;
  final SupabaseClient _supabase;

  @override
  Future<ProfileModel> getCurrentProfile() async {
    try {
      final response = _supabase.auth.currentUser;
      if (response == null) {
        throw NullResponseException();
      }
      return ProfileModel.fromSupabaseUser(response);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<ProfileModel> getProfileWithId(String id) async {
    try {
      final response = await _supabase.auth.admin.getUserById(id);

      if (response.user == null) {
        throw NullResponseException();
      }

      return ProfileModel.fromSupabaseUser(response.user!);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> deleteProfile() async {
    try {
      final currentUser = await getCurrentProfile();

      if (currentUser.id == null) {
        throw NullResponseException();
      }

      await _supabase.auth.admin.deleteUser(currentUser.id!);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Stream<ProfileModel?> get profileStateChanges {
    return _supabase.auth.onAuthStateChange.map((data) {
      try {
        final event = data.event;
        LoggerUtils().logInfo(
          '[AuthRemoteDataSource] : ${data.event}',
        );
        if (event == AuthChangeEvent.userUpdated ||
            event == AuthChangeEvent.signedIn) {
          if (data.session?.user != null) {
            return ProfileModel.fromSupabaseUser(data.session!.user);
          }
        }
      } on AuthException catch (e) {
        throw AuthException(e.message, code: e.code);
      } on Exception catch (_) {
        throw UnknownException();
      }
      return null;
    });
  }

  @override
  Future<void> updateProfile(ProfileModel? newProfile) async {
    try {
      final currentProfile = await getCurrentProfile();
      final updatedProfile = newProfile ?? currentProfile;

      final finalEmail = updatedProfile.email != currentProfile.email
          ? updatedProfile.email
          : null;

      final updatedProfileData = <String, dynamic>{
        'full_name': updatedProfile.fullName != currentProfile.fullName
            ? updatedProfile.fullName
            : null,
        'avatar_url': updatedProfile.avatarUrl != currentProfile.avatarUrl
            ? updatedProfile.avatarUrl
            : null,
      }..removeWhere((k, v) => v == null);

      if (finalEmail == null && updatedProfileData.isEmpty) {
        LoggerUtils().logInfo('No profile updates detected.');
        return;
      }

      final updatedUserAttributes = UserAttributes(
        email: finalEmail,
        data: updatedProfileData.isNotEmpty ? updatedProfileData : null,
      );

      await _supabase.auth.updateUser(updatedUserAttributes);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<String> uploadProfilePhoto(XFile imageFile) async {
    try {
      LoggerUtils().logInfo('Uploading profile photo: ${imageFile.path}');
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;

      final storageResponse =
          await _supabase.storage.from('profiles').uploadBinary(
                filePath,
                bytes,
                fileOptions: FileOptions(contentType: imageFile.mimeType),
              );

      if (storageResponse.isEmpty) {
        throw DatabaseException();
      }

      final photoUrl =
          _supabase.storage.from('profiles').getPublicUrl(fileName);

      LoggerUtils().logInfo('Photo URL: $photoUrl');
      return photoUrl;
    } on StorageException catch (e) {
      throw StorageException(e.message);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }
}
