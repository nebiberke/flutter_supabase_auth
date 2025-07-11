import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_supabase_auth/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';

class UCGetAllOtherProfilesExcept
    implements UseCase<List<ProfileEntity>, NoParams> {
  UCGetAllOtherProfilesExcept({
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
        LoggerUtils().logError(
          'Auth on UCGetAllOtherProfilesExcept: Current user is null or empty',
        );
        return Left(AuthFailure.fromCode('user_not_found'));
      }

      final allProfilesResult = await _repository.getAllOtherProfilesExcept(
        currentUser.id,
      );

      return allProfilesResult.fold(Left.new, (profiles) {
        return Right(profiles);
      });
    });
  }
}
