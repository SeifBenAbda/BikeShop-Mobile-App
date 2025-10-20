import 'package:flutter/material.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

import '../../widgets/bottom_nav.dart';

var currentWorkerScreen = ValueNotifier("W_H");


List<NavOptions> workerHomeOptions = [
    NavOptions(
        optionName: 'home',
        optionQuickAcess: "W_H",
        optionIcon: Icons.home_outlined,
        optionRivIcon: RiveIcon.home),
    NavOptions(
        optionName: "orders",
        optionQuickAcess: "W_ORDERS_PAGE",
        optionIcon: Icons.receipt_long_outlined,
        optionRivIcon: RiveIcon.menuDots),
    NavOptions(
        optionName: "profile",
        optionQuickAcess: "W_PROFILE",
        optionIcon: Icons.person_3_outlined,
        optionRivIcon: RiveIcon.profile)
  ];