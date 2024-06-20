import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';

class AdminOrdersPage extends StatefulWidget {
  final VoidCallback toggleDrawer;
  const AdminOrdersPage({super.key,required this.toggleDrawer});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          adminOrdersTopContainer(),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }



  Widget adminOrdersTopContainer(){
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              drawerBtnWidget(),
              const Spacer(),
              Text(
                getText(context, "orders").toUpperCase(),
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
        widget.toggleDrawer();
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