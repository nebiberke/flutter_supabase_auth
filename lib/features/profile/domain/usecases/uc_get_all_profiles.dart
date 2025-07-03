import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';

class UCGetAllProfiles implements UseCase<List<ProfileEntity>, NoParams> {
  UCGetAllProfiles({
    required ProfileRepository repository,
    required AuthRepository authRepository,
  }) : _repository = repository,
       _authRepository = authRepository;

  final ProfileRepository _repository;
  final AuthRepository _authRepository;

  @override
  Future<Either<Failure, List<ProfileEntity>>> call(NoParams params) async {
    final currentUserResult = await _authRepository.getCurrentUser();

    return await currentUserResult.fold(Left.new, (currentUser) async {
      if (currentUser == null || currentUser.id.isEmpty) {
        return const Left(DatabaseFailure());
      }

      final allProfilesResult = await _repository.getAllProfiles();

      return allProfilesResult.fold(Left.new, (profiles) {
        final filtered = profiles
            .where((profile) => profile.id != currentUser.id)
            .toList();
        return Right(filtered);
      });
    });
  }
}
