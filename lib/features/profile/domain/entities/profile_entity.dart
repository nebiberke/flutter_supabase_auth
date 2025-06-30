import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.g.dart';

@JsonSerializable()
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.username,
  });

  factory ProfileEntity.empty() => const ProfileEntity(
    id: '',
    email: '',
    fullName: '',
    avatarUrl: '',
    username: '',
  );

  factory ProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileEntityToJson(this);

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? username,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      username: username ?? this.username,
    );
  }

  final String id;
  final String email;
  final String fullName;
  final String avatarUrl;
  final String username;

  @override
  List<Object?> get props => [id, email, fullName, avatarUrl, username];
}
