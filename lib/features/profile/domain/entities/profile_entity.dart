import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';
part 'profile_entity.g.dart';

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  const factory ProfileEntity({
    required String id,
    required String email,
    required String fullName,
    required String username,
    String? avatarUrl,
  }) = _ProfileEntity;

  factory ProfileEntity.fromJson(Map<String, Object?> json) =>
      _$ProfileEntityFromJson(json);

  /// Empty [ProfileEntity].
  static const empty = ProfileEntity(
    id: '',
    email: '',
    fullName: '',
    avatarUrl: '',
    username: '',
  );
}
