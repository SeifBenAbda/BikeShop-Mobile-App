import 'package:bikeshop/models/order_class.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:bikeshop/services/user_services.dart';
import 'package:flutter/material.dart';

import '../../../services/superbase_service.dart';
import '../../../widgets/appointment_picker.dart';
import 'fix_bike_vars.dart';

void initiateBasket() {
  totalAmountOrder.value = 0.0;
  final SupabaseService supabaseService = SupabaseService();
  final client = supabaseService.getSuperbaseClient();
  final userId = client.auth.currentUser!.id;
  Order order = Order(
      orderId: "order_$userId",
      orderUserId: userId,
      orderedServices: ValueNotifier([]),
      totalAmount: ValueNotifier(0),
      discountCode: TextEditingController(text: ""),
      discountAmount: ValueNotifier("0"),
      orderComment: TextEditingController(text: ""),
      appointmentDate: ValueNotifier(DateTime.now()),
       isFinished: null, 
       finishedAt: null, 
       workerId: '', 
       workerComments: null, 
       isStarted: null, 
       startedAt: null, 
       isCanceled: null, 
       canceledAt: null, payementMethod: '', orderDate: null, serviceCount: null, orderOwnerName: "${myUser!.lastName} ${myUser!.firstName}");

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

void updateAppointementDay() {
  currentOrder!.appointmentDate.value = dateTimeAppoitmentNotifier.value;
}
