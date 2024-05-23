import 'package:flutter/material.dart';

import '../../models/order_class.dart';
import '../order_service.dart';

class ClientOrdersProvider extends ChangeNotifier {
  List<Order> _clientOrders = [];
  List<Order> get clientOrders => _clientOrders;

  Future<List<Order>> getClientOrders() async {
    List<Order> listOrders = [];
    OrderService os = OrderService();
    await os.getUserOrdersWithServiceCount().then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        listOrders = [];
      }

      listOrders = listOfOrders;
    });

    _clientOrders = listOrders;
    notifyListeners();

    return listOrders;
  }
}
