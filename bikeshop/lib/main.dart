import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'routes/route_names.dart';
import 'routes/routes.dart';
import 'services/superbase_service.dart';
import 'utils/storage/storage.dart';
import 'utils/theme/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  // ignore: prefer_const_constructors
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: bgColor, // navigation bar color
    statusBarColor: bgColor, // status bar color
  ));
  //await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(SupabaseService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BIKE HCI',
      theme: theme,
      getPages: Routes.routes,
      defaultTransition: Transition.noTransition,
      initialRoute:
          Storage.userSession != null ? RouteNames.home : RouteNames.login,
    );
  }
}

