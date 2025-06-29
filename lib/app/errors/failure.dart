import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_supabase_auth/app/l10n/app_l10n.g.dart';

/// A base class for all the failures in the app
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

final class UnknownFailure extends Failure {
  const UnknownFailure();

  @override
  List<Object?> get props => [];
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure();

  @override
  List<Object?> get props => [];
}

final class NullResponseFailure extends Failure {
  const NullResponseFailure();

  @override
  List<Object?> get props => [];
}

final class NoInternetFailure extends Failure {
  const NoInternetFailure();

  @override
  List<Object?> get props => [];
}

/// Represents an authentication failure.
///
/// The error message is localized and should be displayed using `.tr()`.
final class AuthFailure extends Failure {
  /// Creates an [AuthFailure] with an optional message.
  const AuthFailure([String? message])
    : message = message ?? LocaleKeys.errors_messages_auth_error;

  /// Maps an error [code] to a user-friendly message.
  ///
  /// The returned message should be localized using `.tr()`.
  factory AuthFailure.fromCode(String? code, {String? message}) {
    final seconds =
        RegExp(r'(\d+) seconds?\.').firstMatch(message ?? '')?.group(1) ?? '3';
    switch (code) {
      case 'invalid_credentials':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_invalid_credentials,
        );
      case 'email_exists':
        return const AuthFailure(LocaleKeys.errors_messages_auth_email_exists);
      case 'email_not_confirmed':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_email_not_confirmed,
        );
      case 'user_already_exists':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_user_already_exists,
        );
      case 'user_not_found':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_user_not_found,
        );
      case 'weak_password':
        return const AuthFailure(LocaleKeys.errors_messages_auth_weak_password);
      case 'signup_disabled':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_signup_disabled,
        );
      case 'over_request_rate_limit':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_over_request_rate_limit,
        );
      case 'over_email_send_rate_limit':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_over_email_send_rate_limit,
        );
      case 'session_expired':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_session_expired,
        );
      case 'user_banned':
        return const AuthFailure(LocaleKeys.errors_messages_auth_user_banned);
      case 'otp_expired':
        return const AuthFailure(LocaleKeys.errors_messages_auth_otp_expired);
      case 'phone_exists':
        return const AuthFailure(LocaleKeys.errors_messages_auth_phone_exists);
      case 'phone_not_confirmed':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_phone_not_confirmed,
        );
      case 'over_sms_send_rate_limit':
        return AuthFailure(
          LocaleKeys.errors_messages_auth_over_sms_rate_limit.tr(
            namedArgs: {'seconds': seconds},
          ),
        );
      case 'google_sign_in_error':
        return const AuthFailure(
          LocaleKeys.errors_messages_auth_google_sign_in_error,
        );
      default:
        return const AuthFailure(LocaleKeys.errors_messages_auth_error);
    }
  }

  /// The user-friendly error message.
  final String message;

  @override
  List<Object?> get props => [message];
}
