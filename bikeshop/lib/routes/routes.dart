

import 'package:bikeshop/views/auth/login_page.dart';
import 'package:bikeshop/views/home/home_page.dart';
import 'package:get/route_manager.dart';

import 'route_names.dart';

class Routes {
  static final routes = [
    GetPage(name: RouteNames.home, page: () => const HomePage()),
    GetPage(name: RouteNames.login, page: () => const LoginPage()),
  ];
}