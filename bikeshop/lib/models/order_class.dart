import 'package:bikeshop/models/shop_service_class.dart';
import 'package:flutter/material.dart';

class Order {
  final String orderId;
  final String orderUserId;
  final ValueNotifier<List<ShopService>> orderedServices;
  final ValueNotifier totalAmount;
  final TextEditingController discountCode;
  final ValueNotifier discountAmount;
  final TextEditingController orderComment;
  final ValueNotifier<DateTime> appointmentDate;
  final ValueNotifier<DateTime>? orderDate;

  //--addons
  final ValueNotifier? isFinished;
  final DateTime? finishedAt;
  final String? workerId;
  final ValueNotifier? workerComments;
  final ValueNotifier? isStarted;
  final ValueNotifier? startedAt;
  final ValueNotifier? isCanceled;
  final ValueNotifier? canceledAt;

  final String? payementMethod;

  final int? serviceCount;

  final String? orderOwnerName;

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
