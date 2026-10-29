import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Network connectivity service monitoring real-time connection state.
class NetworkService {
  NetworkService() {
    _init();
  }

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(true);
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _init() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('[NetworkService] Check connectivity error: $e');
      isConnectedNotifier.value = true;
    }

    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (Object error) {
        debugPrint('[NetworkService] Stream error: $error');
      },
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool hasConnection = results.any(
      (ConnectivityResult result) => result != ConnectivityResult.none,
    );
    if (isConnectedNotifier.value != hasConnection) {
      isConnectedNotifier.value = hasConnection;
      debugPrint('[NetworkService] Connection changed: $hasConnection');
    }
  }

  Future<bool> checkConnection() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      final bool hasConnection = results.any(
        (ConnectivityResult result) => result != ConnectivityResult.none,
      );
      isConnectedNotifier.value = hasConnection;
      return hasConnection;
    } catch (_) {
      return true;
    }
  }

  void dispose() {
    _subscription?.cancel();
    isConnectedNotifier.dispose();
  }
}
