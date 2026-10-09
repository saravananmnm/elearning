import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(connectivity: ref.read(connectivityProvider));
});

/// Stream provider listening to real-time OS connectivity events (Wi-Fi/Cellular toggles)
final connectivityStreamProvider = StreamProvider<bool>((ref) async* {
  final connectivity = ref.read(connectivityProvider);
  final networkInfo = ref.read(networkInfoProvider);

  // Initial check
  yield await networkInfo.isConnected;

  // Real-time OS event listener
  await for (final results in connectivity.onConnectivityChanged) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      yield false;
    } else {
      yield await networkInfo.isConnected;
    }
  }
});

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    try {
      final results = await connectivity.checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
