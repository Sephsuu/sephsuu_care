import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  Future<bool> get isOnline async {
    final results = await Connectivity().checkConnectivity();

    return !results.contains(ConnectivityResult.none);
  }

  Stream<List<ConnectivityResult>> get onConnectionChanged {
    return Connectivity().onConnectivityChanged;
  }
}