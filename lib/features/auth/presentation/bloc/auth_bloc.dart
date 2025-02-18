import 'package:flutter_supabase_auth/core/enums/auth_status.dart';
import 'package:flutter_supabase_auth/core/usecases/usecase.dart';
import 'package:flutter_supabase_auth/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_auth_state_changes.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_in.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_out.dart';
import 'package:flutter_supabase_auth/features/auth/domain/usecases/uc_sign_up.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_supabase_auth/features/auth/presentation/bloc/auth_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  AuthBloc({
    required UCSignIn signIn,
    required UCSignUp signUp,
    required UCSignOut signOut,
    required UCAuthStateChanges authStateChanges,
  })  : _signIn = signIn,
        _signUp = signUp,
        _signOut = signOut,
        _authStateChanges = authStateChanges,
        super(AuthState()) {
    on<SignInEvent>(_onSignInEvent);
    on<SignUpEvent>(_onSignUpEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<AuthStateChangesEvent>(_onCheckAuthStatusEvent);
  }
  final UCSignIn _signIn;
  final UCSignUp _signUp;
  final UCSignOut _signOut;
  final UCAuthStateChanges _authStateChanges;

  Future<void> _onCheckAuthStatusEvent(
    AuthStateChangesEvent event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authStateChanges(NoParams()),
      onData: (data) => data.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            failure: failure,
          ),
        ),
        (auth) {
          return emit(
            state.copyWith(
              status: auth != null
                  ? AuthStatus.authenticated
                  : AuthStatus.unauthenticated,
              auth: auth,
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSignInEvent(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          failure: failure,
        ),
      ),
      (auth) {
        return emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            auth: auth,
          ),
        );
      },
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
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
        ),
      ),
    );
  }

  Future<void> _onSignOutEvent(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _signOut(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.error,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
        ),
      ),
    );
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      return AuthState(
        status: AuthStatus.values[json['status'] as int],
        auth: AuthEntity.fromJson(json['auth'] as Map<String, dynamic>),
      );
    } on Exception catch (_) {
      return AuthState();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'status': state.status.index,
      'auth': state.auth?.toJson(),
    };
  }
}
