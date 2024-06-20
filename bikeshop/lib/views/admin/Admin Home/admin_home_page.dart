import 'dart:math';

import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/admin/Admin%20All%20Orders/admin_orders.dart';
import 'package:bikeshop/views/admin/Admin%20Worker%20Management/admin_worker_management.dart';
import 'package:flutter/material.dart';

import '../Admin Dashboard/admin_dashboard.dart';
import '../Inventory Management/admin_inventory.dart';
import '../admin_vars.dart';
import 'drawer_admin.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
    with SingleTickerProviderStateMixin {
  double value = 0;

  void toggleDrawer() {
    setState(() {
      value == 0 ? value = 1 : value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyColor,
        body: Stack(
          children: <Widget>[
            DrawerAdmin(toggleDrawer: toggleDrawer),
            mainWidget(),
            GestureDetector(
              onHorizontalDragUpdate: (e) {
                if (e.delta.dx > 0) {
                  setState(() {
                    value = 1;
                  });
                } else {
                  setState(() {
                    value = 0;
                  });
                }
              },
            )
          ],
        ));
  }

  Widget mainWidget() {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: value),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        builder: (_, double val, __) {
          return (Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..setEntry(0, 3, 200 * val)
              ..rotateY((pi / 6) * val),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Scaffold(
                  body: ValueListenableBuilder(
                      valueListenable: currentAdminScreen,
                      builder: (context, value, _) {
                        return mainAdminWidget();
                      })),
            ),
          ));
        });
  }

  Widget mainAdminWidget() {
    switch (currentAdminScreen.value) {
      case "A_D":
        return adminHomePageWidget();
      case "A_LAGER":
        return AdminInventory(
          toggleDrawer: toggleDrawer,
        );
      case "A_HIRE":
        return AdminWorkerManagement(toggleDrawer: toggleDrawer);
      case "A_ORDERS":
        return AdminOrdersPage(toggleDrawer: toggleDrawer);
      default:
        return adminHomePageWidget();
    }
  }

  Widget adminHomePageWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          adminHomePageContainer(),
          const SizedBox(
            height: 30,
          ),
          const AdminDashboard()
        ],
      ),
    );
  }

  Widget adminHomePageContainer() {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              drawerBtnWidget(),
              const Spacer(),
              Text(
                getText(context, "dashboard").toUpperCase(),
                style: getTextStyleAbel(25, greyColor),
              ),
              const Spacer(),
            ],
          )),
    );
  }

  Widget drawerBtnWidget() {
    return GestureDetector(
      onTap: () {
        toggleDrawer();
      },
      child: Container(
        decoration: getBoxDeco(12, greyColor),
        height: 50,
        width: 50,
        child: const Center(
          child: Icon(
            Icons.menu_outlined,
            color: blueColor,
          ),
        ),
      ),
    );
  }
}
