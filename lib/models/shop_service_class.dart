import 'package:flutter/material.dart';

class ShopService {
  final int serviceId;
  final String serviceName;
  final String serviceNameGerman;
  final String serviceImage;
  final double servicePrice;
  final Duration serviceDuration;
  final ValueNotifier isServiceAvailable;
  final ValueNotifier serviceDiscount;
  final ValueNotifier
      activeClientsOnService; //check if there is surchage on Service

  final ValueNotifier isInBasket;

  ValueNotifier<bool>? isFinished ;

  ShopService({
    required this.serviceId,
    required this.serviceName,
    required this.serviceNameGerman,
    required this.serviceImage,
    required this.servicePrice,
    required this.serviceDuration,
    required this.isServiceAvailable,
    required this.serviceDiscount,
    required this.activeClientsOnService,
    required this.isInBasket,
    this.isFinished, 
  });

  toJson() {}
}
