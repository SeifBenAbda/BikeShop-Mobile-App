import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';
import 'admin_adding_worker.dart';

class AdminWorkerManagement extends StatefulWidget {
  final VoidCallback toggleDrawer;
  const AdminWorkerManagement({super.key, required this.toggleDrawer});

  @override
  State<AdminWorkerManagement> createState() => _AdminWorkerManagementState();
}

class _AdminWorkerManagementState extends State<AdminWorkerManagement> {
  var isAddWorkerPressed = ValueNotifier(false);
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
          workerManagementTopContainer(),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: isAddWorkerPressed,
                  builder: (context, value, _) {
                    if (isAddWorkerPressed.value) {
                      return const AddWorkerPage();
                    }
                    return workersListWidget();
                  }))
        ],
      ),
    );
  }

  //----- List of Current Workers --------------------------------

  Widget workersListWidget() {
    return Column();
  }

  Widget workerManagementTopContainer() {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              drawerBtnWidget(),
              const Spacer(),
              Text(
                getText(context, "workerManagement").toUpperCase(),
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
