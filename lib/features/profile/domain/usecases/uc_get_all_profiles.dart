import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';

class UCGetAllProfiles implements UseCase<List<ProfileEntity>, NoParams> {
  UCGetAllProfiles({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, List<ProfileEntity>>> call(NoParams params) {
    return _repository.getAllProfiles();
  }
}
