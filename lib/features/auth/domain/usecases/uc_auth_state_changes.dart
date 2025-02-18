import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';

class UCAuthStateChanges implements StreamUseCase<AuthEntity?, NoParams> {
  UCAuthStateChanges({required AuthRepository repository})
      : _repository = repository;

  final AuthRepository _repository;

  @override
  Stream<Either<Failure, AuthEntity?>> call(NoParams params) {
    return _repository.authStateChanges;
  }
}
