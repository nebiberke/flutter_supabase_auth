import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';

class UCSignIn implements UseCase<AuthEntity, SignInParams> {
  UCSignIn({required AuthRepository repository}) : _repository = repository;
  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthEntity>> call(SignInParams params) {
    return _repository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
