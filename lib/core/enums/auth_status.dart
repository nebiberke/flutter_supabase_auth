/// An enum that represents the status of the authentication process.
///
/// Example usage:
/// ```dart
/// AuthStatus.initial;
/// AuthStatus.loading;
/// AuthStatus.authenticated;
/// AuthStatus.unauthenticated;
/// AuthStatus.error;
/// ```
enum AuthStatus {
  /// The initial status of the authentication process.
  initial,

  /// The loading status of the authentication process.
  loading,

  /// The authenticated status of the authentication process.
  authenticated,

  /// The unauthenticated status of the authentication process.
  unauthenticated,

  /// The error status of the authentication process.
  error,
}
