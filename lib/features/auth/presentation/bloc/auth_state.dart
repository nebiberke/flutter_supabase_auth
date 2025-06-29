import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.failure, this.user});

  factory AuthState.initial() => const AuthState();

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final Failure? failure;
  final User? user;

  AuthState copyWith({AuthStatus? status, Failure? failure, User? user}) {
    return AuthState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, failure, user];
}
