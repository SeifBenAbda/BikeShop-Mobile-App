import 'package:bikeshop/models/shop_service_class.dart';
import 'package:flutter/material.dart';

class OrderDetails {
  final String orderId;
  final String orderUserId;
  final ValueNotifier<List<ShopService>> orderedServices;
  final ValueNotifier totalAmount;
  final TextEditingController discountCode;
  final ValueNotifier discountAmount;
  final TextEditingController orderComment;
  final ValueNotifier<DateTime> appointmentDate;
  //final 

  OrderDetails({
    required this.orderId,
    required this.orderUserId,
    required this.orderedServices,
    required this.totalAmount,
    required this.discountCode,
    required this.discountAmount,
    required this.orderComment,
    required this.appointmentDate
  });
}
