import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_model.freezed.dart';

@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({
    required String userId,
    required String accessToken,
    @Default(false) bool isTokenExpired,
    @Default([]) List<String> providers,
  }) = _AuthModel;

  factory AuthModel.fromSupabase(Session? response) {
    final appMetadata = response?.user.appMetadata ?? {};
    final dynamic rawProviders = appMetadata['providers'];
    final providers = rawProviders is List
        ? rawProviders.map((e) => e.toString()).toList()
        : <String>[];
    final accessToken = response?.accessToken ?? '';
    final isTokenExpired = response?.isExpired ?? false;
    final userId = response?.user.id ?? '';

    return AuthModel(
      userId: userId,
      accessToken: accessToken,
      isTokenExpired: isTokenExpired,
      providers: providers,
    );
  }
}

extension AuthModelX on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      accessToken: accessToken,
      isTokenExpired: isTokenExpired,
      providers: providers,
    );
  }
}
