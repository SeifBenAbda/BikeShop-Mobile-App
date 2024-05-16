import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_vars.dart';

String getTotalDurationBakset() {
  double duration = 0.0;

  for (int i = 0; i < currentOrder!.orderedServices.value.length; i++) {
    double serviceDuration = currentOrder!.orderedServices.value
        .elementAt(i)
        .serviceDuration
        .inMinutes
        .toDouble();
    duration += serviceDuration;
  }

  return "$duration Min";
}

String getTotalPrice() {
  String totalPrice = totalAmountOrder.value.toStringAsFixed(2);
  return "$totalPrice €";
}
