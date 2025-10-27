import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../utils/logger/catalyst_logger.dart';

/// Network connectivity status
enum NetworkStatus {
  online,
  offline,
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  other,
}

/// Connectivity Service for monitoring network status
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final CatalystLogger _logger = CatalystLogger();

  StreamController<NetworkStatus>? _statusController;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  NetworkStatus _currentStatus = NetworkStatus.offline;

  /// Get current network status
  NetworkStatus get currentStatus => _currentStatus;

  /// Stream of network status changes
  Stream<NetworkStatus> get onStatusChange {
    _statusController ??= StreamController<NetworkStatus>.broadcast();
    return _statusController!.stream;
  }

  /// Check if device is online
  bool get isOnline => _currentStatus != NetworkStatus.offline;

  /// Check if connected to WiFi
  bool get isWifi => _currentStatus == NetworkStatus.wifi;

  /// Check if connected to mobile data
  bool get isMobile => _currentStatus == NetworkStatus.mobile;

  /// Initialize connectivity service
  Future<void> initialize() async {
    try {
      // Get initial connectivity status
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result);

      // Listen to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateStatus,
        onError: (error) {
          _logger.error('Connectivity error: $error');
        },
      );

      _logger.info('✅ Connectivity Service initialized');
    } catch (e) {
      _logger.error('Error initializing connectivity service: $e');
    }
  }

  /// Update network status
  void _updateStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      _currentStatus = NetworkStatus.offline;
    } else {
      final result = results.first;
      switch (result) {
        case ConnectivityResult.wifi:
          _currentStatus = NetworkStatus.wifi;
          break;
        case ConnectivityResult.mobile:
          _currentStatus = NetworkStatus.mobile;
          break;
        case ConnectivityResult.ethernet:
          _currentStatus = NetworkStatus.ethernet;
          break;
        case ConnectivityResult.bluetooth:
          _currentStatus = NetworkStatus.bluetooth;
          break;
        case ConnectivityResult.vpn:
          _currentStatus = NetworkStatus.vpn;
          break;
        case ConnectivityResult.other:
          _currentStatus = NetworkStatus.other;
          break;
        case ConnectivityResult.none:
          _currentStatus = NetworkStatus.offline;
          break;
      }
    }

    _logger.debug('Network status: $_currentStatus');
    _statusController?.add(_currentStatus);
  }

  /// Check connectivity
  Future<NetworkStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateStatus(results);
      return _currentStatus;
    } catch (e) {
      _logger.error('Error checking connectivity: $e');
      return NetworkStatus.offline;
    }
  }

  /// Wait for connection
  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (isOnline) return;

    final completer = Completer<void>();
    late StreamSubscription<NetworkStatus> subscription;

    subscription = onStatusChange.listen((status) {
      if (status != NetworkStatus.offline) {
        completer.complete();
        subscription.cancel();
      }
    });

    await completer.future.timeout(
      timeout,
      onTimeout: () {
        subscription.cancel();
        throw TimeoutException('Connection timeout');
      },
    );
  }

  /// Dispose connectivity service
  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    await _statusController?.close();
    _logger.info('Connectivity Service disposed');
  }
}

/// Network Info - Additional network information
class NetworkInfo {
  final NetworkStatus status;
  final String? ipAddress;
  final String? ssid;
  final int? signalStrength;
  final DateTime timestamp;

  NetworkInfo({
    required this.status,
    this.ipAddress,
    this.ssid,
    this.signalStrength,
    required this.timestamp,
  });

  bool get isConnected => status != NetworkStatus.offline;

  @override
  String toString() {
    return 'NetworkInfo(status: $status, ip: $ipAddress, ssid: $ssid, signal: $signalStrength)';
  }
}
