import 'package:flutter/material.dart';

class Item {
  final String id;
  final String name;
  final String nameGerman;
  final double price;
  final String image;
  ValueNotifier stock;

  Item({
    required this.id,
    required this.name,
    required this.nameGerman,
    required this.price,
    required this.image,
    required this.stock,
  });
}


class RequestedItems {
  final String requestId;
  final String itemId;
  final String workerId;
  final String clientId;
  ValueNotifier isAccepted;
  DateTime? requestTime;
  ValueNotifier isCanceled;

  RequestedItems({
    required this.requestId,
    required this.itemId,
    required this.workerId,
    required this.clientId,
    required this.isAccepted,
    required this.requestTime,
    required this.isCanceled,
  });
}
