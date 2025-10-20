import 'package:bikeshop/models/item_class.dart';
import 'package:bikeshop/models/order_class.dart';
import 'package:bikeshop/services/superbase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemsService {
  final SupabaseService _supabaseService = SupabaseService();

  //--------------Send Order to Server From Client--------------------------//

  Future<List<Item>> getItemsFromServer() async {
    List<Item> itemsList = [];
    try {
      final client = _supabaseService.getSuperbaseClient();
      final response = await client.from("items").select();

      for (var myItem in response) {
        Item item = createItem(myItem);
        itemsList.add(item);
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }

    return itemsList;
  }

  Future<List<RequestedItems>> getRequestedMaintancePerOrder(
      Order order) async {
    List<RequestedItems> rqItemsList = [];
    try {
      final client = _supabaseService.getSuperbaseClient();
      final response = await client
          .from("bicyclemaintenance")
          .select()
          .eq("order_id", order.orderId);

      for (var myItem in response) {
        RequestedItems requestedItem = createRequestedItem(myItem);
        rqItemsList.add(requestedItem);
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }

    return rqItemsList;
  }

  Item createItem(dynamic myItem) {
    Item item = Item(
      id: myItem["item_id"].toString(),
      name: myItem["name_english"],
      nameGerman: myItem["name_german"],
      price: double.parse(myItem["price"].toString()),
      image: myItem["image_path"],
      stock: ValueNotifier(myItem["stock"]),
    );

    return item;
  }

  RequestedItems createRequestedItem(dynamic myRqItem) {
    RequestedItems rqItem = RequestedItems(
        requestId: myRqItem["maintenance_id"].toString(),
        itemId: myRqItem["item_id"].toString(),
        workerId: myRqItem["worker_id"].toString(),
        clientId: myRqItem["user_id"].toString(),
        isAccepted:
            ValueNotifier(myRqItem["request_accepted"].toString() == "true"),
        requestTime: myRqItem["request_date"].toString()=="null"?null: DateTime.parse(myRqItem["request_date"]),
        isCanceled:
            ValueNotifier(myRqItem["request_undone"].toString() == "true"));

    return rqItem;
  }

  //this function request an Item
  Future<void> requestItemChangeWorker(Order order, Item item) async {
    Map<String, dynamic> requestData = {
      "worker_id": order.workerId,
      "user_id": order.orderUserId,
      "item_id": item.id,
      "order_id": order.orderId,
      "request_accepted": false.toString(),
      "request_date": DateTime.now().toString(),
      "request_undone": false.toString(),
    };
    try {
      final client = _supabaseService.getSuperbaseClient();

      await client.from('bicyclemaintenance').insert(requestData);
    } on FunctionException catch (error) {
      print('Error invoking function: $error');
    } catch (error) {
      print('Error inserting order: $error');
    }
  }

  //this function refuses the Item requested by the Worker
  Future<void> requestItemResponse(Order order,RequestedItems reqIte,bool isAccepted) async {
    String orderId = order.orderId;
    String itemId = reqIte.itemId;
    Map<String, dynamic> requestData = {
      "request_accepted": isAccepted.toString(),
      "request_date":!isAccepted? null:reqIte.requestTime.toString(),
    };
    try {
      final client = _supabaseService.getSuperbaseClient();

      await client
          .from('bicyclemaintenance')
          .update(requestData).match(
              {'order_id': orderId,'item_id':itemId});
    } on FunctionException catch (error) {
      print('Error invoking function: $error');
    } catch (error) {
      print('Error inserting order: $error');
    }
  }



  //-- this function is responsable to re-request a declined previous request 
  Future<void> requestItemAfterDecline(Order order,RequestedItems reqIte) async {
    String orderId = order.orderId;
    String itemId = reqIte.itemId;
    Map<String, dynamic> requestData = {
      "request_accepted": false.toString(),
      "request_date":DateTime.now().toString(),
    };
    try {
      final client = _supabaseService.getSuperbaseClient();

      await client
          .from('bicyclemaintenance')
          .update(requestData).match(
              {'order_id': orderId,'item_id':itemId});
    } on FunctionException catch (error) {
      print('Error invoking function: $error');
    } catch (error) {
      print('Error inserting order: $error');
    }
  }
}
