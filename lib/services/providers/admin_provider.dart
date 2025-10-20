import 'package:bikeshop/models/user_class.dart';
import 'package:bikeshop/services/admin_service.dart';
import 'package:flutter/material.dart';


class AdminProvider extends ChangeNotifier {
  List<Users> _workersList = [];
  List<Users> get workersList => _workersList;
  AdminService as = AdminService();
  Future<List<Users>> getWorkersList() async {
    List<Users> workersList = [];

    await as.getWorkersFromServer().then((workersServer) {
      if (workersServer.isEmpty) {
        workersList = [];
      }

      workersList = workersServer;
    });

    _workersList = workersList;
    notifyListeners();

    return workersList;
  }
}
