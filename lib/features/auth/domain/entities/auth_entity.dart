import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entity.g.dart';

@JsonSerializable()
class AuthEntity extends Equatable {
  const AuthEntity({
    required this.userId,
    required this.accessToken,
    required this.isTokenExpired,
    required this.providers,
  });

  factory AuthEntity.empty() => const AuthEntity(
        userId: '',
        accessToken: '',
        isTokenExpired: false,
        providers: [],
      );

  factory AuthEntity.fromJson(Map<String, dynamic> json) =>
      _$AuthEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AuthEntityToJson(this);

  final String userId;
  final String accessToken;
  final bool isTokenExpired;
  final List<String> providers;

  @override
  List<Object> get props => [userId, accessToken, isTokenExpired, providers];
}
