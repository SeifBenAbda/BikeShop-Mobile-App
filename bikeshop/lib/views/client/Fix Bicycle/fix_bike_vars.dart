import 'package:bikeshop/models/order_class.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:flutter/material.dart';

List<ShopService> listOfShopServices = [];

var isBasketBikeFixActive = ValueNotifier(false);

//---Ordering Part
Order? currentOrder;
var totalAmountOrder = ValueNotifier(0.0);
var discountAmount = ValueNotifier("0");

var numberOfItemsBasket = ValueNotifier(0);
