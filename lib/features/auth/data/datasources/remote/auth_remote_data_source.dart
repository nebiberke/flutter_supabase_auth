import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<User> signIn({required String email, required String password});

  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  });

  Future<void> signOut();

  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required SupabaseClient supabase})
    : _supabase = supabase;
  final SupabaseClient _supabase;

  @override
  Future<User> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw NullResponseException();
      }

      return response.user!;
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on NullResponseException catch (_) {
      throw NullResponseException();
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'username': username},
      );

      if (response.user == null) {
        throw NullResponseException();
      }

      return response.user!;
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on NullResponseException catch (_) {
      throw NullResponseException();
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  User? getCurrentUser() {
    try {
      return _supabase.auth.currentUser;
    } on Exception catch (_) {
      throw UnknownException();
    }
  }
}
