import 'package:flutter/material.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

import '../../../widgets/bottom_nav.dart';

var currentActiveScreenClient = ValueNotifier("H");



List<NavOptions> clientHomeOptions = [
    NavOptions(
        optionName: 'home',
        optionQuickAcess: "H",
        optionIcon: Icons.home_outlined,
        optionRivIcon: RiveIcon.home),
    NavOptions(
        optionName: "orders",
        optionQuickAcess: "C_ORDERS",
        optionIcon: Icons.receipt_long_outlined,
        optionRivIcon: RiveIcon.menuDots),
    NavOptions(
        optionName: "profile",
        optionQuickAcess: "C_PROFILE",
        optionIcon: Icons.person_3_outlined,
        optionRivIcon: RiveIcon.profile)
  ];