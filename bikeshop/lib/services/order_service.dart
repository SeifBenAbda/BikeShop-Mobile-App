import 'package:bikeshop/models/order_class.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../views/worker/Order Management/worker_all_orders.dart';
import 'superbase_service.dart';
import 'package:intl/intl.dart';

class OrderService {
  final SupabaseService _supabaseService = SupabaseService();

  

  //--------------Send Order to Server From Client--------------------------//

  Future<bool> sendOrderToServer(Order order) async {
    final client = _supabaseService.getSuperbaseClient();
    Map<String, dynamic> orderData = {
      "order_id": order.orderId.toString(),
      "user_id": order.orderUserId,
      "payment_method": "TBD",
      "order_date": DateTime.now().toString(),
      "total_price": order.totalAmount.value.toString(),
      "is_canceled": false.toString(),
      "comment": "",
      "discount_code": "",
      "discount_amount": 0,
      "appointment_day": order.appointmentDate.value.toString(),
      "service_count": order.orderedServices.value.length.toString(),
      "isAvailable": false.toString()
    };

    // Insert the order data
    try {
      final response =
          await client.from('user_order').insert(orderData).select();
      if (response.isNotEmpty) {
        int serviceIndex = 1;
        for (ShopService service in order.orderedServices.value) {
          await client.from('user_order_details').insert({
            'order_detail_id':
                '${response[0]["order_id"]}_details_$serviceIndex',
            'order_id': response[0]["order_id"],
            'service_id': service.serviceId
          }).then((value) {
            serviceIndex++;
          });
        }
      } else {
        print('Error inserting order: Response is null');
      }
    } on FunctionException catch (error) {
      print('Error invoking function: $error');
    } catch (error) {
      print('Error inserting order: $error');
    }

    return true;
  }

  //----Client Orders Getting-----------------------------------//

  Future<List<Order>> getUserOrdersWithServiceCount() async {
    List<Order> orderList = [];
    try {
      final client = _supabaseService.getSuperbaseClient();
      final userId = client.auth.currentUser!.id;
      final response =
          await client.from("user_order").select().eq("user_id", userId);

      for (var userOrder in response) {
        Order order = createOrder(userOrder,true);
        orderList.add(order);
      }
    } catch (error) {
      // Handle error
      print('Error: $error');
    }

    return orderList;
  }

  //----------------This returns the List of orders that a Worker can access when the worker_id is null--------------------------//
  Future<List<Order>> getOpenedOrders() async {
    List<Order> orderList = [];

    try {
      final client = _supabaseService.getSuperbaseClient();
      final response =
          await client.from("user_order").select().eq("isAvailable", true);
      for (var userOrder in response) {
        Order order = createOrder(userOrder,true);
        orderList.add(order);
      }
    } catch (error) {
      print("Error: $error");
    }

    return orderList;
  }

  //-------------------Assign an Open Order to a Worker -------------------------------//

  Future<void> assignOrderToWorker(Order order) async {
    try {
      final client = _supabaseService.getSuperbaseClient();
      final userId = client.auth.currentUser!.id;
      await client
          .from('user_order')
          .update({'worker_id': userId, 'isAvailable': false.toString()}).match(
              {'order_id': order.orderId});
    } catch (error) {
      print("Error: $error");
    }
  }

  //-- ------------------Get today's tasks for specific Worker------------------------//
  Future<List<Order>> getTodayOrderToWorker() async {
    List<Order> orderList = [];
    try {
      final client = _supabaseService.getSuperbaseClient();
      final userId = client.auth.currentUser!.id;
      final response = await client.rpc('gettodaystaskperworker', params: {
        'my_worker_id': userId,
        'target_date': setupDateForServerFetch(DateTime.now())
      });

      for (var userOrder in response) {
        Order order = createOrder(userOrder,false);
        orderList.add(order);
      }
    } catch (error) {
      print("Error: $error");
    }

    return orderList;
  }

  //------------ Get All Orders Detailles (With Services) From Datababase---------------------//

  List<Order> orderList = [];
  Future<List<Order>> getOrdersDetailled() async {
    try {
      final client = _supabaseService.getSuperbaseClient();
      final response = await client.rpc('get_all_orders_detailled');
      for (var userOrder in response) {
        Order order = createOrder(userOrder,false);
        int orderIndex =
            orderList.indexWhere((element) => element.orderId == order.orderId);
        if (orderIndex == -1) {
          orderList.add(order);
          modifyOrderServices(order, userOrder, false, null);
        } else {
          order = orderList.elementAt(orderIndex);
          updateOrder(userOrder, order);
          modifyOrderServices(order, userOrder, true, order);
        }
      }
    } catch (error) {
      print("Errorssssssssssssss: $error");
    }

    return orderList;
  }

  //------------------ get All Worker Tasks (With Services) From Database --------------------//
  List<Order> workerOrders = allOrdersWorker;
  Future<List<Order>> getWorkerAllOrdersWithServices() async {
    try {
      final client = _supabaseService.getSuperbaseClient();
      final userId = client.auth.currentUser!.id;
      final response = await client.rpc('get_worker_orders', params: {
        'myworkerid': userId,
      });

      for (var userOrder in response) {
        Order order = createOrder(userOrder,false);
        int orderIndex = workerOrders
            .indexWhere((element) => element.orderId == order.orderId);
        if (orderIndex == -1) {
          workerOrders.add(order);
          modifyOrderServices(order, userOrder, false, null);
        } else {
          //order = workerOrders.elementAt(orderIndex);
          updateOrder(userOrder, workerOrders.elementAt(orderIndex));
          modifyOrderServices(workerOrders.elementAt(orderIndex), userOrder,
              true, workerOrders.elementAt(orderIndex));
          //orderList.add(order);
          //modifyOrderServices(order, userOrder,true);
          //print("Order Already Exists");
        }
      }
    } catch (error) {
      print("Error: $error");
    }

    return workerOrders;
  }

  //------ Adding / Modifiying Existing Services Within an Order-----------------------//

  void modifyOrderServices(
      Order order, dynamic userOrder, bool orderExists, Order? existingOrder) {
    ShopService service = createService(userOrder);
    int index = existingOrder == null
        ? -1
        : existingOrder.orderedServices.value
            .indexWhere((element) => element.serviceId == service.serviceId);
    if (index != -1) {
      order.orderedServices.value = existingOrder!.orderedServices.value;
    } else {
      order.orderedServices.value.add(service);
    }
  }

  ShopService createService(dynamic userOrder) {
    ShopService result = ShopService(
        serviceId: userOrder["serviceid"],
        serviceName: userOrder["servicename"].toString(),
        serviceNameGerman: userOrder["de_servicename"].toString(),
        serviceImage: userOrder["serviceimage"].toString(),
        servicePrice: double.parse(userOrder["serviceprice"].toString()),
        serviceDuration: Duration(
            minutes: int.parse(userOrder["servicedurationminutes"].toString())),
        isServiceAvailable: ValueNotifier(true),
        serviceDiscount: ValueNotifier(
            double.parse(userOrder["servicediscount"].toString())),
        activeClientsOnService: ValueNotifier(0),
        isInBasket: ValueNotifier(false));

    return result;
  }

  //---------------- Creating an Order Instance fron Json Data-----------------------//

  Order createOrder(dynamic userOrder,bool isClientRequest) {
    Order order = Order(
        orderId: userOrder["order_id"].toString(),
        orderUserId: userOrder["user_id"].toString(),
        orderedServices: ValueNotifier([]),
        totalAmount: ValueNotifier(userOrder["total_price"].toString()),
        discountCode: TextEditingController(text: userOrder["discount_code"]),
        discountAmount: ValueNotifier(0.0),
        orderComment:
            TextEditingController(text: userOrder["comment"].toString()),
        appointmentDate: ValueNotifier(
            DateTime.parse(userOrder["appointment_day"].toString())),
        isFinished:
            ValueNotifier(userOrder["is_finished"].toString() == "true"),
        finishedAt: userOrder["finished_at"].toString().toLowerCase() == "null"
            ? null
            : DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS")
                .parse(userOrder["finished_at"].toString()),
        workerId: userOrder["worker_id"].toString(),
        workerComments: ValueNotifier(userOrder["worker_comments"].toString()),
        isStarted: ValueNotifier(userOrder["is_started"].toString() == "true"),
        startedAt: userOrder["started_at"].toString().toLowerCase() == "null"
            ? null
            : DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS")
                .parse(userOrder["started_at"].toString()),
        isCanceled:
            ValueNotifier(userOrder["is_canceled"].toString() == "true"),
        canceledAt: null,
        payementMethod: userOrder["payment_method"].toString(),
        orderDate:
            ValueNotifier(DateTime.parse(userOrder["order_date"].toString())),
        serviceCount: userOrder["service_count"],
        orderOwnerName:isClientRequest?null:
            userOrder["user_last_name"] + " " + userOrder["user_first_name"]);

    return order;
  }

  //-------------- Updating Order  - Targetting Special Attributes in Class Order------------//

  void updateOrder(dynamic userOrder, Order existingOrder) {
    existingOrder.workerId = userOrder["worker_id"].toString();

    existingOrder.orderComment =
        TextEditingController(text: userOrder["comment"].toString());

    existingOrder.isFinished =
        ValueNotifier(userOrder["is_finished"].toString() == "true");

    existingOrder.finishedAt =
        userOrder["finished_at"].toString().toLowerCase() == "null"
            ? null
            : DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS")
                .parse(userOrder["finished_at"].toString());

    existingOrder.workerComments =
        ValueNotifier(userOrder["worker_comments"].toString());

    existingOrder.isStarted =
        ValueNotifier(userOrder["is_started"].toString() == "true");

   /* existingOrder.startedAt =
        userOrder["started_at"].toString().toLowerCase() == "null"
            ? null
            : DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS")
                .parse(userOrder["started_at"].toString());*/

    existingOrder.isCanceled =
        ValueNotifier(userOrder["is_canceled"].toString() == "true");
  }

  //--------------Worker Updating a Specific Order------------------------//
  Future<bool> updateOrderToServer(Order order) async {
    print("Strating time : ${order.startedAt.toString()}");
    print(order.workerComments!.value.toString());
    final client = _supabaseService.getSuperbaseClient();
    final workerId = client.auth.currentUser!.id;
    bool isFinished = order.isFinished!.value;
    bool isStarted = order.isStarted!.value;
    dynamic startedAt = order.startedAt.toString();
    dynamic finishedAt = order.finishedAt.toString();
    Map<String, dynamic> orderData = {
      "worker_comments": order.workerComments!.value.toString(),
      "isAvailable": false.toString(),
      "is_started": isStarted.toString(),
      "started_at": startedAt == "null" ? null : startedAt,
      "is_finished": isFinished.toString(),
      "finished_at": finishedAt == "null" ? null : finishedAt,
    };

    // Insert the order data
    try {
      await client.from('user_order').update(orderData).match({
        'order_id': order.orderId.toString(),
        'worker_id': workerId.toString()
      });
    } on FunctionException catch (error) {
      print('Error invoking function: $error');
    } catch (error) {
      print('Error updating order: $error');
    }

    return true;
  }



  //--------------Client Updating Order Comments -----------------------------//
  Future<bool> updateClientOrderComments(Order order) async {
     final client = _supabaseService.getSuperbaseClient();
    Map<String, dynamic> orderData = {
     "comment":order.orderComment.text,
    };

    // Insert the order data
    try {
      await client.from('user_order').update(orderData).match({
        'order_id': order.orderId.toString(),
      });
    } on FunctionException catch (error) {
      print('Error invoking function: $error');
    } catch (error) {
      print('Error updating order client comments: $error');
    }

    return true;
  }
}
