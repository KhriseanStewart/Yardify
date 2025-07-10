import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// connection_status.dart
class ConnectionStatus {
  static final ConnectionStatus _instance = ConnectionStatus._internal();

  bool isConnected = false;

  factory ConnectionStatus() {
    return _instance;
  }

  ConnectionStatus._internal();
}

class CheckInternet {
  bool _isDialogShown = false;
  bool connected = false;

  Future<void> checkInitialConnectivity(
    Connectivity _connectivity,
    context,
  ) async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Couldnt check connection status: $e");
    }
    return updateConnectionStatus(result, context);
  }

  Future<void> updateConnectionStatus(
    List<ConnectivityResult> results,
    context,
  ) async {
    // Check if any result indicates no connection
    connected = results.any((result) => result == ConnectivityResult.none);
    print(connected);

    connected = ConnectionStatus().isConnected;

    if (connected) {
      if (!_isDialogShown) {
        _isDialogShown = true; // prevent multiple dialogs
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('No Internet Connection'),
            content: Text('Please check your internet connection.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _isDialogShown = false; // reset flag
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
