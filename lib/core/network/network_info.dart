import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Abstract interface for checking internet connectivity.
/// This allows for different implementations, such as mocking for unit tests.
abstract interface class NetworkInfo {
  /// Returns `true` if the device is actually connected to the internet,
  /// otherwise `false`.
  Future<bool> get isConnected;

  /// Returns a stream that emits the current internet connectivity status.
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] that uses
/// [InternetConnection] to check the device's internet status.
final class NetworkInfoImpl implements NetworkInfo {
  /// Creates an instance of [NetworkInfoImpl] with a required
  /// [InternetConnection] dependency.
  const NetworkInfoImpl({required this.connectionChecker});

  /// The dependency responsible for checking internet connectivity.
  final InternetConnection connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;

  /// Returns a stream that emits the current internet connectivity status.
  @override
  Stream<bool> get onConnectivityChanged => connectionChecker.onStatusChange
      .map((status) => status == InternetStatus.connected);
}
