import 'dart:io';

import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/views/client/Client%20Home/client_home_vars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:toastification/toastification.dart';

import '../../views/client/Fix Bicycle/fix_bike_vars.dart';

Future<bool> checkInternet() async {
  bool isConnected = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      isConnected = true;
    }
  } on SocketException catch (_) {
    isConnected = false;
  }
  return isConnected;
}

String getText(BuildContext context, String key) {
  return FlutterI18n.translate(context, key);
}

void showError(BuildContext context, String errorMsg) {
  toastification.show(
    icon: Image.asset("assets/images/warning.png", height: 30, width: 30),
    context: context, // optional if you use ToastificationWrapper
    title: Text(
      errorMsg,
      style: getTextStyleAbel(14, greyColor),
    ),
    backgroundColor: blueColor,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void showErrorLogin(BuildContext context, String errorMsg) {
  toastification.show(
    icon: Image.asset("assets/images/warning.png", height: 30, width: 30),
    context: context, // optional if you use ToastificationWrapper
    title: Text(
      errorMsg,
      style: getTextStyleAbel(14, greyColor),
    ),
    backgroundColor: optionConColor,
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void showSucess(BuildContext context, String suceessMsg) {
  toastification.show(
    icon: Image.asset("assets/images/accept.png", height: 30, width: 30),
    context: context, // optional if you use ToastificationWrapper
    title: Text(
      suceessMsg,
      style: getTextStyleAbel(14, greyColor),
    ),
    backgroundColor: blueColor,
    autoCloseDuration: const Duration(seconds: 2),
  );
}

bool isSmallScreen(BuildContext context) {
  return MediaQuery.of(context).size.width < 800;
}

bool isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 1200;
}

bool isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width <= 1200;
}

void goBackButtonFunction() {}

void goHomePageClient() {
  currentActiveScreenClient.value = "H";
  totalAmountOrder.value = 0.0;
}
