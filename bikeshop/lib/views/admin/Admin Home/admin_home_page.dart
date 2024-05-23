import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';

import '../admin_vars.dart';



class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: bgColor, body: mainAdminWidget());
  }

  Widget mainAdminWidget() {
    switch (currentAdminScreen.value) {
      case "W_H":
        return adminHomePageWidget();

      default:
        return adminHomePageWidget();
    }
  }

  Widget adminHomePageWidget() {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          appLogoWidget()
        ],
      ),
    );
  }

  Widget appLogoWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Center(
        child: Image.asset(
          "assets/images/app_logo.png",
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
