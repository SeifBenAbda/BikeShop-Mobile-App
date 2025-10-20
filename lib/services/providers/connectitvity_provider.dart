import 'dart:io';

import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _haveInternet = false;
  bool get isInternetAvailable => _haveInternet;

  Future<bool> checkInternet() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    _haveInternet = isConnected;
    notifyListeners();
    return isConnected;
  }
}
