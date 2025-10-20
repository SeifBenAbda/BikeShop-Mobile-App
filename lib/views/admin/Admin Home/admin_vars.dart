import 'package:flutter/material.dart';

import '../../../widgets/bottom_nav.dart';

List<NavOptions> adminHomeOptions = [
    NavOptions(
        optionName: 'dashboard',
        optionQuickAcess: "A_D",
        optionIcon: Icons.dashboard,
        optionRivIcon: null),
    NavOptions(
        optionName: "orders",
        optionQuickAcess: "A_ORDERS",
        optionIcon: Icons.receipt_long_outlined,
        optionRivIcon: null),
    NavOptions(
        optionName: "warehouse",
        optionQuickAcess: "A_LAGER",
        optionIcon: Icons.inventory_2_outlined,
        optionRivIcon: null),     
    NavOptions(
        optionName: "hireWorker",
        optionQuickAcess: "A_HIRE",
        optionIcon: Icons.person_add_outlined,
        optionRivIcon: null),    
    NavOptions(
        optionName: "profile",
        optionQuickAcess: "A_PROFILE",
        optionIcon: Icons.person_3_outlined,
        optionRivIcon: null)
  ];