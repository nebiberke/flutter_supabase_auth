import 'package:flutter_supabase_auth/app/errors/exceptions.dart';
import 'package:flutter_supabase_auth/core/utils/logger/logger_utils.dart';
import 'package:flutter_supabase_auth/features/auth/data/models/auth_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> signIn({
    required String email,
    required String password,
  });

  Future<AuthModel> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> signOut();

  Stream<AuthModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required SupabaseClient supabase,
  }) : _supabase = supabase;
  final SupabaseClient _supabase;

  @override
  Future<AuthModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw NullResponseException();
      }

      return AuthModel.fromSupabase(response.session);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<AuthModel> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.user == null) {
        throw NullResponseException();
      }

      return AuthModel.fromSupabase(response.session);
    } on AuthException catch (e) {
      throw AuthException(e.message, code: e.code);
    } on Exception catch (_) {
      throw UnknownException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on Exception catch (_) {
      UnknownException();
    }
  }

  @override
  Stream<AuthModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.where((data) {
      return {AuthChangeEvent.initialSession, AuthChangeEvent.tokenRefreshed}
          .contains(data.event);
    }).map((data) {
      try {
        LoggerUtils().logInfo(
          '[AuthRemoteDataSource] : ${data.event}',
        );
        return data.session?.user != null
            ? AuthModel.fromSupabase(data.session)
            : null;
      } on AuthException catch (e) {
        throw AuthException(e.message, code: e.code);
      } on Exception catch (_) {
        throw UnknownException();
      }
    });
  }
}
