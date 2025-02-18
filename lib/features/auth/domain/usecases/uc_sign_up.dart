import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';

class UCSignUp implements UseCase<AuthEntity, SignUpParams> {
  UCSignUp({required AuthRepository repository}) : _repository = repository;
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthEntity>> call(SignUpParams params) {
    return _repository.signUp(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
    );
  }
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
  final String email;
  final String password;
  final String fullName;

  @override
  List<Object> get props => [email, password, fullName];
}
