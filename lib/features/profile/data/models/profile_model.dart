import 'package:flutter/foundation.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.fromSupabaseUser(User user) {
    final metadata = user.userMetadata ?? {};
    final id = user.id;
    final email = user.email;
    final fullName = metadata['full_name'] as String?;
    final avatarUrl = metadata['avatar_url'] as String?;
    // final createdAt = data['created_at'];
    // final parsedCreatedAt =
    //     createdAt != null ? DateTime.tryParse(createdAt.toString()) : null;

    return ProfileModel(
      id: id,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      avatarUrl: entity.avatarUrl,
    );
  }
}

extension ProfileModelX on ProfileModel {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id ?? ProfileEntity.empty().id,
      email: email ?? ProfileEntity.empty().email,
      fullName: fullName ?? ProfileEntity.empty().fullName,
      avatarUrl: avatarUrl ?? ProfileEntity.empty().avatarUrl,
    );
  }
}
