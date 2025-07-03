import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';

class UCUpdateProfile implements UseCase<Unit, UpdateProfileParams> {
  UCUpdateProfile({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UpdateProfileParams params) {
    return _repository.updateProfile(params.profile);
  }
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({required this.profile});
  final ProfileEntity profile;

  @override
  List<Object> get props => [profile];
}
