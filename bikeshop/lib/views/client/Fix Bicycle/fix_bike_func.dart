import 'package:bikeshop/models/order_class.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:flutter/material.dart';

import '../../../services/superbase_service.dart';
import 'fix_bike_vars.dart';

void initiateBasket() {
  totalAmountOrder.value = 0.0;
  final SupabaseService _supabaseService = SupabaseService();
  final client = _supabaseService.getSuperbaseClient();
  final userId = client.auth.currentUser!.id;
  Order order = Order(
      orderId: "order_$userId",
      orderUserId: userId,
      orderedServices: ValueNotifier([]),
      totalAmount: ValueNotifier(0),
      discountCode: TextEditingController(text: ""),
      discountAmount: ValueNotifier("0"),
      orderComment: TextEditingController(text: ""));

  currentOrder = order;
}



void updateOrderTotalAmount() {
  currentOrder!.totalAmount.value = totalAmountOrder.value;
}

void updateOrderDiscountAmount() {
  currentOrder!.discountAmount.value = discountAmount.value;
}

bool isServiceInBasket(ShopService service) {
  return currentOrder!.orderedServices.value.indexWhere(
          (shopService) => shopService.serviceId == service.serviceId) !=
      -1;
}


