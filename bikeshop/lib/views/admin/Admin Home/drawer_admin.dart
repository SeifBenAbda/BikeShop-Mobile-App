import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';

import '../../../widgets/bottom_nav.dart';
import '../../auth/login_register_controller.dart';
import '../admin_vars.dart';
import 'admin_vars.dart';

class DrawerAdmin extends StatefulWidget {
  final VoidCallback toggleDrawer;

  const DrawerAdmin({super.key, required this.toggleDrawer});

  @override
  State<DrawerAdmin> createState() => _DrawerAdminState();
}

class _DrawerAdminState extends State<DrawerAdmin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width / 1.5,
        color: greyColor,
        child: Column(
          children: <Widget>[
            Column(
              children: [
                welcomeTextWidget(),
                const SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < adminHomeOptions.length; i++)
                  Column(
                    children: [
                      adminDrawerOption(adminHomeOptions.elementAt(i)),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            logoutBtnWidget(),
          ],
        ),
      ),
    );
  }

  Widget welcomeTextWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.7,
      child: Text(
        getText(context, "welcomeBack"),
        style: getTextStyleAbel(18, bgColor),
      ),
    );
  }

  Widget adminDrawerOption(NavOptions adminNavOption) {
    return GestureDetector(
      onTap: () {
        changeAdminScreen(adminNavOption.optionQuickAcess!);
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 50,
          decoration: isActiveAdminOption(adminNavOption.optionQuickAcess!)
              ? getBoxDeco(12, greenColor2)
              : getBoxDeco(12, bgColor),
          width: MediaQuery.of(context).size.width / 1.95,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getText(context, adminNavOption.optionName!),
                style: getTextStyleAbel(15, greyColor),
              ),
              Icon(
                adminNavOption.optionIcon,
                size: 20,
                color: greyColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget logoutBtnWidget() {
    return GestureDetector(
      onTap: () async{
        await controller.logout();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          height: 50,
          decoration: getBoxDeco(12, redColor),
          width: MediaQuery.of(context).size.width / 1.95,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getText(context, "logout"),
                style: getTextStyleAbel(15, greyColor),
              ),
              const Icon(
                Icons.logout,
                size: 20,
                color: greyColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isActiveAdminOption(String optionRoute) {
    return currentAdminScreen.value == optionRoute;
  }

  void changeAdminScreen(String adminRoute) {
    setState(() {
      currentAdminScreen.value = adminRoute;
    });
  }
}
