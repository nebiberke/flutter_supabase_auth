import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    String? email,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? username,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

/// Convert a [ProfileModel] to a [ProfileEntity].
extension ProfileModelX on ProfileModel? {
  ProfileEntity toEntity() {
    return ProfileEntity(
      id: this?.id ?? ProfileEntity.empty.id,
      email: this?.email ?? ProfileEntity.empty.email,
      fullName: this?.fullName ?? ProfileEntity.empty.fullName,
      avatarUrl: this?.avatarUrl ?? ProfileEntity.empty.avatarUrl,
      username: this?.username ?? ProfileEntity.empty.username,
    );
  }
}

/// Convert a [ProfileEntity] to a [ProfileModel].
extension ProfileEntityX on ProfileEntity {
  ProfileModel toModel() {
    return ProfileModel(
      id: id,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
      username: username,
    );
  }
}
