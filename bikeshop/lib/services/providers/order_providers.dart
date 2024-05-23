import 'package:flutter/material.dart';

import '../../models/order_class.dart';
import '../order_service.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _myOrdersList = [];
  List<Order> get myOrdersList => _myOrdersList;

  Future<List<Order>> getOpenOrders() async {
    List<Order> listOrders = [];
    OrderService os = OrderService();
    await os.getOpenedOrders().then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        listOrders = [];
      }

      listOrders = listOfOrders;
    });

    _myOrdersList = listOrders;
    notifyListeners();

    return listOrders;
  }

}


class TasksOfDayProvider extends ChangeNotifier{
   List<Order> _myOrdersList = [];
  List<Order> get orderList => _myOrdersList;
  Future<List<Order>> getWorkerTasksDay() async {
    List<Order> listOrders = [];
    OrderService os = OrderService();
    await os.getTodayOrderToWorker().then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        listOrders = [];
      }

      listOrders = listOfOrders;
    });

    _myOrdersList = listOrders;
    notifyListeners();

    return listOrders;
  }
}



class WorkerAllOrdersProvider extends ChangeNotifier{
   List<Order> _myOrdersList = [];
  List<Order> get orderList => _myOrdersList;
  Future<List<Order>> getWorkerAllOrdersWithServices() async {
    List<Order> listOrders = [];
    OrderService os = OrderService();
    await os.getWorkerAllOrdersWithServices().then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        listOrders = [];
      }

      listOrders = listOfOrders;
    });

    _myOrdersList = listOrders;
    notifyListeners();

    return listOrders;
  }
}

