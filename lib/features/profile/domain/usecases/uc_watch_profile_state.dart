import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';

class UCWatchProfileState
    implements StreamUseCase<ProfileEntity?, WatchProfileStateParams> {
  UCWatchProfileState({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  @override
  Stream<Either<Failure, ProfileEntity?>> call(WatchProfileStateParams params) {
    return _repository.watchProfileState(params.userId);
  }
}

class WatchProfileStateParams extends Equatable {
  const WatchProfileStateParams({required this.userId});
  final String userId;

  @override
  List<Object?> get props => [userId];
}
