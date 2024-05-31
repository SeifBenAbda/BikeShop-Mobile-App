import '../../models/order_class.dart';

String getOrderDuration(Order order) {
  int duration = 0;

  for (var myOrder in order.orderedServices.value) {
    duration += myOrder.serviceDuration.inMinutes;
  }

  return "$duration Min";
}
