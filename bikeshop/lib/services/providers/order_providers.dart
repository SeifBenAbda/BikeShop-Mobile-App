import 'package:flutter/material.dart';

import '../../models/order_class.dart';
import '../../utils/Global Folder/global_func.dart';
import '../order_service.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _myOrdersList = [];
  List<Order> get myOrdersList => _myOrdersList;

  List<Order> filterOpenedOrders() {
    List<Order> openedOrders = _myOrdersList.where((order) {
      final workerId = order.workerId.toString().toLowerCase();
      return workerId == "null";
    }).toList();
    return openedOrders;
  }

  Future<List<Order>> getAllOrdersDetailled() async {
    List<Order> listOrders = [];
    OrderService os = OrderService();
    await os.getOrdersDetailled().then((listOfOrders) {
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

class TasksOfDayProvider extends ChangeNotifier {
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

class WorkerAllOrdersProvider extends ChangeNotifier {
  List<Order> _myOrdersList = [];
  List<Order> get orderList => _myOrdersList;

  List<Order> filterOrdersWorkerToday() {
    List<Order> todaysTasksWorker = _myOrdersList.where((order) {
      final dateOfAppointment =
          setupDateForServerFetch(order.appointmentDate.value);
      return dateOfAppointment == setupDateForServerFetch(DateTime.now());
    }).toList();
    return todaysTasksWorker;
  }

  List<Order> filterOrdersWorker(String searchValue) {
    List<Order> todaysTasksWorker = _myOrdersList.where((order) {
      int lastIndexSub = order.orderId.lastIndexOf("_");
      final orderId =
          order.orderId.substring(lastIndexSub + 1, order.orderId.length);
      return orderId.contains(searchValue);
    }).toList();

    return todaysTasksWorker;
  }

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
