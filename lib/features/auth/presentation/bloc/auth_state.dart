import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';

class AuthState extends Equatable {
  AuthState({
    this.status = AuthStatus.initial,
    AuthEntity? auth,
    this.failure,
  }) : auth = auth ?? AuthEntity.empty();

  final AuthStatus status;
  final AuthEntity? auth;
  final Failure? failure;

  AuthState copyWith({
    AuthStatus? status,
    AuthEntity? auth,
    Failure? failure,
  }) {
    return AuthState(
      status: status ?? this.status,
      auth: auth ?? this.auth,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, auth, failure];
}
