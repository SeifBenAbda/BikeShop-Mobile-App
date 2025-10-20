import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LagerItem {
  String? id;
  String? name;
  String? nameGerman;
  double? price;
  ValueNotifier? stock;
  String? image;
  ValueNotifier<bool>? isPriceInModification;
  ValueNotifier<bool>? isStockInModification;

  TextEditingController? priceController;
  TextEditingController? stockController;

  LagerItem({
    required this.id,
    required this.name,
    required this.nameGerman,
    required this.price,
    required this.stock,
    required this.image,
    required this.isPriceInModification,
    required this.isStockInModification,
    required this.priceController,
    required this.stockController
  });
}
