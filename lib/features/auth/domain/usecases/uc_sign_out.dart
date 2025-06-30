import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';

class UCSignOut implements UseCase<Unit, NoParams> {
  UCSignOut({required AuthRepository repository}) : _repository = repository;

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.signOut();
  }
}
