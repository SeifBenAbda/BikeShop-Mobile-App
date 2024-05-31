import 'package:bikeshop/models/shop_service_class.dart';
import 'package:flutter/material.dart';

class Order {
   String orderId;
   String orderUserId;
   ValueNotifier<List<ShopService>> orderedServices;
   ValueNotifier totalAmount;
   TextEditingController discountCode;
   ValueNotifier discountAmount;
   TextEditingController orderComment;
   ValueNotifier<DateTime> appointmentDate;
   ValueNotifier<DateTime>? orderDate;

  //--addons
   ValueNotifier? isFinished;
   DateTime? finishedAt;
   String? workerId;
   ValueNotifier? workerComments;
   ValueNotifier? isStarted;
   DateTime? startedAt;
   ValueNotifier? isCanceled;
   ValueNotifier? canceledAt;

   String? payementMethod;

   int? serviceCount;

   String? orderOwnerName;

  Order(
      {required this.orderId,
      required this.orderUserId,
      required this.orderedServices,
      required this.totalAmount,
      required this.discountCode,
      required this.discountAmount,
      required this.orderComment,
      required this.appointmentDate,
      required this.isFinished,
      required this.finishedAt,
      required this.workerId,
      required this.workerComments,
      required this.isStarted,
      required this.startedAt,
      required this.isCanceled,
      required this.canceledAt,
      required this.payementMethod,
      required this.orderDate,
      required this.serviceCount,
      required this.orderOwnerName});
}
