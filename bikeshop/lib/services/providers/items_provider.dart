import 'package:bikeshop/models/item_class.dart';
import 'package:bikeshop/models/order_class.dart';
import 'package:flutter/material.dart';

import '../items_service.dart';

class ItemsProvider extends ChangeNotifier {
  List<Item> _itemsList = [];
  List<RequestedItems> _rqitemsList = [];
  List<Item> get listItems => _itemsList;
  List<RequestedItems> get listRequestedItems => _rqitemsList;
  Future<List<Item>> getItemsFromProvider() async {
    List<Item> itemsList = [];
    ItemsService iss = ItemsService();
    await iss.getItemsFromServer().then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        itemsList = [];
      }

      itemsList = listOfOrders;
    });

    _itemsList = itemsList;
    notifyListeners();

    return itemsList;
  }


  Future<List<RequestedItems>> getRequestsItemsForOrder(Order order) async {
    List<RequestedItems> rqItemsList = [];
    ItemsService iss = ItemsService();
    await iss.getRequestedMaintancePerOrder(order).then((listOfOrders) {
      if (listOfOrders.isEmpty) {
        rqItemsList = [];
      }

      rqItemsList = listOfOrders;
    });

    _rqitemsList = rqItemsList;
    notifyListeners();

    return rqItemsList;
  }
}