import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/profile/domain/repositories/profile_repository.dart';
import 'package:image_picker/image_picker.dart';

class UCUploadProfilePhoto
    implements UseCase<String, UploadProfilePhotoParams> {
  UCUploadProfilePhoto({required ProfileRepository repository})
    : _repository = repository;

  final ProfileRepository _repository;

  @override
  Future<Either<Failure, String>> call(UploadProfilePhotoParams params) {
    return _repository.uploadProfilePhoto(params.imageFile, params.userId);
  }
}

class UploadProfilePhotoParams extends Equatable {
  const UploadProfilePhotoParams({
    required this.imageFile,
    required this.userId,
  });
  final XFile imageFile;
  final String userId;

  @override
  List<Object> get props => [imageFile, userId];
}
