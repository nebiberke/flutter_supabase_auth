import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UCSignUp implements UseCase<User, SignUpParams> {
  UCSignUp({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      username: params.username,
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({
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
  List<Object?> get props => [email, password, fullName, username];
}
