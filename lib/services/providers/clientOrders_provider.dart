import 'package:flutter/material.dart';

import '../../models/order_class.dart';
import '../order_service.dart';
import '../superbase_service.dart';

class ClientOrdersProvider extends ChangeNotifier {
  List<Order> _clientOrders = [];
  List<Order> get clientOrders => _clientOrders;

  Future<List<Order>> getClientOrders() async {
    List<Order> listOrders = [];
    OrderService os = OrderService();
    final SupabaseService supabaseService = SupabaseService();
    final client = supabaseService.getSuperbaseClient();
    final clientId = client.auth.currentUser!.id;
    await os.getOrdersDetailled().then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        listOrders = [];
      }

      listOrders = listOfOrders.where((order) {
        String clientOrderId = order.orderUserId;
        return clientOrderId == clientId;
      }).toList();
    });

    _clientOrders = listOrders;
    notifyListeners();

    return listOrders;
  }
}
