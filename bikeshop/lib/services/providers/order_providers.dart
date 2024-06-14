import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/views/admin/Admin%20Dashboard/global_stats.dart';
import 'package:flutter/material.dart';

import '../../models/order_class.dart';
import '../../utils/Global Folder/global_func.dart';
import '../order_service.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _myOrdersList = [];
  List<Order> get myOrdersList => _myOrdersList;
  List<GridData> gridList = [];
  GridData openedOrdersGrid = GridData(
      orderType: "openOrders",
      numberOders: ValueNotifier(0),
      gridColor: greyColor2,
      textColor: blueColor);
  GridData closedOrdersGrid = GridData(
      orderType: "completedOrders",
      numberOders: ValueNotifier(0),
      gridColor: blueColor1,
      textColor: greyColor);

  GridData goingOrdersGrid = GridData(
      orderType: "ongoingOrders",
      numberOders: ValueNotifier(0),
      gridColor: greenColor,
      textColor: greyColor);

  List<GridData> getGlobalStatsList() {
    List<Order> openedOrders = _myOrdersList.where((order) {
      final workerId = order.workerId.toString().toLowerCase();
       final isClosed = order.isFinished!.value;
      final isStarted = order.isStarted!.value;
      return workerId == "null" || (!isStarted && !isClosed);
    }).toList();

    List<Order> closedOrders = _myOrdersList.where((order) {
      final isClosed = order.isFinished!.value;
      return isClosed;
    }).toList();

    List<Order> onGoingOrders = _myOrdersList.where((order) {
      final isClosed = order.isFinished!.value;
      final isStarted = order.isStarted!.value;
      return !isClosed && isStarted;
    }).toList();

    openedOrdersGrid.numberOders!.value = openedOrders.length;
    closedOrdersGrid.numberOders!.value = closedOrders.length;
    goingOrdersGrid.numberOders!.value = onGoingOrders.length;
    if (!gridList.contains(openedOrdersGrid)) {
      gridList.add(openedOrdersGrid);
    }

    if (!gridList.contains(closedOrdersGrid)) {
      gridList.add(closedOrdersGrid);
    }

    if (!gridList.contains(goingOrdersGrid)) {
      gridList.add(goingOrdersGrid);
    }

    return gridList;
  }

  List<Order> filterOpenedOrders() {
    List<Order> openedOrders = _myOrdersList.where((order) {
      final workerId = order.workerId.toString().toLowerCase();
      return workerId == "null";
    }).toList();
    return openedOrders;
  }

  //this filters orders per date to get recent orders for adomin dashboard
  List<Order> filterRecentOrders() {
    // Get the current date
    final now = DateTime.now();

    // Sort the orders by the difference in days between the order date and the current date
    _myOrdersList.sort((a, b) {
      final dateA =
          a.orderDate!.value; // Assuming orderDate is of type DateTime
      final dateB = b.orderDate!.value;

      final diffA = (dateA.difference(now)).abs();
      final diffB = (dateB.difference(now)).abs();

      return diffA.compareTo(diffB);
    });

    return _myOrdersList.take(3).toList();
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
