import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  const SignInEvent({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.username,
  });
  final String email;
  final String password;
  final String fullName;
  final String username;

  @override
  List<Object> get props => [email, password, fullName, username];
}

class SignOutEvent extends AuthEvent {}

class AuthStartedEvent extends AuthEvent {}
