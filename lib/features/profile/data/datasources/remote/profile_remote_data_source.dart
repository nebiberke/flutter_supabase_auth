import 'dart:developer';

import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/profile/data/models/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfileWithId(String userId);
  Stream<ProfileModel?> watchProfileState(String userId);
  Future<void> updateProfile(ProfileModel newProfile);
  Future<String> uploadProfilePhoto(XFile imageFile, String userId);
  Future<List<ProfileModel>> getAllOtherProfilesExcept(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({required SupabaseClient supabase})
    : _supabase = supabase;
  final SupabaseClient _supabase;

  @override
  Future<ProfileModel?> getProfileWithId(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return ProfileModel.fromJson(response);
      }

      return null;
    } on PostgrestException catch (e) {
      throw PostgrestException(message: e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Stream<ProfileModel?> watchProfileState(String userId) {
    return _supabase
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .takeWhile((_) {
          return _supabase.auth.currentUser != null;
        })
        .map(
          (rows) => rows.isNotEmpty ? ProfileModel.fromJson(rows.first) : null,
        )
        .handleError((Object error, StackTrace stackTrace) {
          if (error is PostgrestException) {
            throw PostgrestException(message: error.message, code: error.code);
          } else if (error is RealtimeSubscribeException) {
            throw RealtimeSubscribeException(error.status);
          }
          throw UnknownException();
        });
  }

  @override
  Future<void> updateProfile(ProfileModel newProfile) async {
    try {
      final currentProfile = await getProfileWithId(newProfile.id);

      if (currentProfile == null) {
        throw const AuthException('User not found', code: 'user_not_found');
      }

      // If the email is not the same, update the email
      final finalEmail = newProfile.email != currentProfile.email
          ? newProfile.email
          : null;

      final updatedProfileData = <String, dynamic>{
        // If the full name is not the same, update the full name
        'full_name': newProfile.fullName != currentProfile.fullName
            ? newProfile.fullName
            : null,
        // If the username is not the same, update the username
        'username': newProfile.username != currentProfile.username
            ? newProfile.username
            : null,
        // If the avatar url is not the same, update the avatar url
        'avatar_url': newProfile.avatarUrl != currentProfile.avatarUrl
            ? newProfile.avatarUrl
            : null,
      }..removeWhere((k, v) => v == null);

      // If there are no updates, return
      if (finalEmail == null && updatedProfileData.isEmpty) {
        LoggerUtils().logInfo('No profile updates detected.');
        return;
      }

      // If the email is not the same, update the email
      if (finalEmail != null) {
        await _supabase.auth.updateUser(UserAttributes(email: finalEmail));
      }

      // Update the profile
      await _supabase
          .from('profiles')
          .update(updatedProfileData)
          .eq('id', newProfile.id);
    } on PostgrestException catch (e) {
      throw PostgrestException(message: e.message, code: e.code);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<String> uploadProfilePhoto(XFile imageFile, String userId) async {
    try {
      LoggerUtils().logInfo('Uploading profile photo: ${imageFile.path}');

      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = '$userId/$fileName';

      // Check if the file already exists
      final existingFiles = await _supabase.storage
          .from('avatars')
          .list(path: userId);

      // If the file already exists, remove it
      if (existingFiles.isNotEmpty) {
        log('existingFiles: ${existingFiles.map((e) => e.name)}');
        await _supabase.storage
            .from('avatars')
            .remove(existingFiles.map((e) => '$userId/${e.name}').toList());
      }

      // Upload the file
      await _supabase.storage
          .from('avatars')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(contentType: imageFile.mimeType),
          );

      // Get the public url of the file
      final photoUrl = _supabase.storage.from('avatars').getPublicUrl(filePath);

      LoggerUtils().logInfo('Photo URL: $photoUrl');
      return photoUrl;
    } on StorageException catch (e) {
      throw StorageException(e.message);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<List<ProfileModel>> getAllOtherProfilesExcept(String userId) async {
    try {
      // Get all profiles except the current user
      final response = await _supabase
          .from('profiles')
          .select()
          .neq('id', userId);

      return response.map(ProfileModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw PostgrestException(message: e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }
}
