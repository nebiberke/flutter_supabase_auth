import 'package:dartz/dartz.dart';
import 'package:flutter_supabase_auth/app/errors/failure.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<Either<Failure, Unit>> signOut();

  Stream<Either<Failure, AuthEntity?>> get authStateChanges;
}
