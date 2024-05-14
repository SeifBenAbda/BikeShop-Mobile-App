import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/views/auth/login_register_controller.dart';
import 'package:flutter/material.dart';

import '../../services/user_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: getUserBn(),
      ),
    );
  }

  Widget getUserBn() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          /*await userService.getUser().then((user) {
            print(user!.id);
          });*/
          await controller.logout();
        },
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width / 1.4,
          decoration: getBoxDeco(10, Colors.white),
          child: Center(
            child: Text(
              "GET USER NOW",
              style: getTextStyleFjallone(16, bgColor),
            ),
          ),
        ),
      ),
    );
  }
}
