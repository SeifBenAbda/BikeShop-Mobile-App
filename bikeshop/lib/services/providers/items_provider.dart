import 'package:bikeshop/models/item_class.dart';
import 'package:bikeshop/models/lager_items_class.dart';
import 'package:bikeshop/models/order_class.dart';
import 'package:flutter/material.dart';

import '../items_service.dart';

class ItemsProvider extends ChangeNotifier {
  List<Item> _itemsList = [];
  List<RequestedItems> _rqitemsList = [];
  List<LagerItem> _lagerItems = [];


  List<Item> get listItems => _itemsList;

  List<RequestedItems> get listRequestedItems => _rqitemsList;

  List<LagerItem> get lagerItems => _lagerItems ;


  Future<List<Item>> getItemsFromProvider() async {
    List<Item> itemsList = [];
    ItemsService iss = ItemsService();
    await iss.getItemsFromServer().then((listOfItems) {
      if (listOfItems.isEmpty) {
        itemsList = [];
      }

      itemsList = listOfItems;
    });

    _itemsList = itemsList;
    notifyListeners();

    return itemsList;
  }

  Future<List<LagerItem>> getLagerItems() async {
    List<LagerItem> lagerItemsList = [];

    ItemsService iss = ItemsService();
    await iss.getItemsFromServer().then((listOfItems) {
      if (listOfItems.isEmpty) {
        lagerItemsList = [];
      }

      for (int i = 0; i < listOfItems.length; i++) {
        LagerItem lgItem = LagerItem(
            id: listOfItems.elementAt(i).id,
            name: listOfItems.elementAt(i).name,
            nameGerman: listOfItems.elementAt(i).nameGerman,
            price: listOfItems.elementAt(i).price,
            stock: ValueNotifier(listOfItems.elementAt(i).stock.value),
            image: listOfItems.elementAt(i).image,
            isPriceInModification: ValueNotifier(false),
            isStockInModification: ValueNotifier(false), priceController: TextEditingController(text: listOfItems.elementAt(i).price.toString()), stockController: TextEditingController());
        lagerItemsList.add(lgItem);
      }
    });

    _lagerItems = lagerItemsList;
    notifyListeners();

    return lagerItemsList;
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
