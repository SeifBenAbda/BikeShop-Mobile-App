// ignore_for_file: depend_on_referenced_packages

import 'package:bikeshop/services/providers/admin_provider.dart';
import 'package:bikeshop/services/providers/items_provider.dart';
import 'package:bikeshop/services/providers/shopServices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'routes/route_names.dart';
import 'routes/routes.dart';
import 'services/providers/clientOrders_provider.dart';
import 'services/providers/connectitvity_provider.dart';
import 'services/providers/order_providers.dart';
import 'services/superbase_service.dart';
import 'utils/Global Folder/global_deco.dart';
import 'utils/storage/storage.dart';
import 'utils/theme/theme.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    //SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  ]);
  // ignore: prefer_const_constructors
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: bgColor, // navigation bar color
    statusBarColor: bgColor, // status bar color
  ));
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(SupabaseService());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ConnectivityProvider>(
      create: (context) => ConnectivityProvider(),
    ),
    ChangeNotifierProvider<ShopServiceProvider>(
      create: (context) => ShopServiceProvider(),
    ),
    ChangeNotifierProvider<ClientOrdersProvider>(
      create: (context) => ClientOrdersProvider(),
    ),
    ChangeNotifierProvider<OrdersProvider>(
      create: (context) => OrdersProvider(),
    ),
    ChangeNotifierProvider<TasksOfDayProvider>(
      create: (context) => TasksOfDayProvider(),
    ),
    ChangeNotifierProvider<WorkerAllOrdersProvider>(
      create: (context) => WorkerAllOrdersProvider(),
    ),
    ChangeNotifierProvider<ItemsProvider>(
      create: (context) => ItemsProvider(),
    ),
    ChangeNotifierProvider<AdminProvider>(
      create: (context) => AdminProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        locale: const Locale('de'), // Set the default locale to German
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              fallbackFile: 'de',
              basePath: 'assets/i18n',
            ),
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
        ],
        debugShowCheckedModeBanner: false,
        title: 'BIKE HCI',
        theme: theme,
        getPages: Routes.routes,
        defaultTransition: Transition.noTransition,
        initialRoute:
            Storage.userSession != null ? RouteNames.home : RouteNames.login,
      );
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
