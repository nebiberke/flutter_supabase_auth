import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_get_current_user.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_up.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required UCSignIn signIn,
    required UCSignUp signUp,
    required UCSignOut signOut,
    required UCGetCurrentUser getCurrentUser,
  }) : _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       _getCurrentUser = getCurrentUser,
       super(const AuthState()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<AuthStartedEvent>(_onAuthStartedEvent);
  }

  final UCSignIn _signIn;
  final UCSignUp _signUp;
  final UCSignOut _signOut;
  final UCGetCurrentUser _getCurrentUser;

  Future<void> _onAuthStartedEvent(
    AuthStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _getCurrentUser(NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.error, failure: failure)),
      (user) {
        if (user != null) {
          emit(AuthState(status: AuthStatus.authenticated, user: user));
        } else {
          emit(const AuthState(status: AuthStatus.unauthenticated));
        }
      },
    );
  }

  Future<void> _onSignInEvent(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signIn(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.error, failure: failure)),
      (user) => emit(AuthState(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onSignUpEvent(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        username: event.username,
      ),
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.error, failure: failure)),
      (user) => emit(AuthState(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> _onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signOut(NoParams());

    result.fold(
      (failure) =>
          emit(state.copyWith(status: AuthStatus.error, failure: failure)),
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }
}
