import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';

class UCGetProfileWithId
    implements UseCase<ProfileEntity, GetProfileWithIdParams> {
  UCGetProfileWithId({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(GetProfileWithIdParams params) {
    return _repository.getProfileWithId(params.userId);
  }
}

class GetProfileWithIdParams extends Equatable {
  const GetProfileWithIdParams({required this.userId});
  final String userId;

  @override
  List<Object?> get props => [userId];
}
