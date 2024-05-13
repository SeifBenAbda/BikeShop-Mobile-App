// * Get Supabase s3 bucket url
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

String getS3Url(String path) {
  return "${Env.supabaseUrl}/storage/v1/object/public/$path";
}

void showSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.white,
    colorText: bgColor,
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
    snackStyle: SnackStyle.GROUNDED,
    margin: const EdgeInsets.all(10.0),
  );
}

// * formate date
String formateDateFromNow(String date) {
  // Parse UTC timestamp string to DateTime
  DateTime utcDateTime = DateTime.parse(date.split('+')[0].trim());

  // Convert UTC to IST (UTC+5:30 for Indian Standard Time)
  DateTime istDateTime = utcDateTime.add(const Duration(hours: 5, minutes: 30));

  // Format the DateTime using Jiffy
  return Jiffy.parseFromDateTime(istDateTime).fromNow();
}