import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user_class.dart';
import '../../../services/providers/admin_provider.dart';
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
  bool isReady = false;
  var isAddWorkerPressed = ValueNotifier(false);

  List<Users> workersList = [];
  double workerContainerHeight = 130;
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
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.getWorkersList().then((value) {
      isReady = true;
    }).onError((error, stackTrace) {
      isReady = true;
    });
    if (!isReady) {
      return Container(
        color: bgColor.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else {
      return Expanded(child: listOfWorkersWidget());
    }
  }

  //-- List of Workers Consumer
  Widget listOfWorkersWidget() {
    return Consumer<AdminProvider>(builder: (context, adminProvider, _) {
      workersList = adminProvider.workersList;
      if (workersList.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < workersList.length; i++)
              Column(
                children: [
                  workerContainerWidget(workersList.elementAt(i)),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )
          ],
        ),
      );
    });
  }

  //---Worker Container Widget
  Widget workerContainerWidget(Users worker) {
    return Container(
      height: workerContainerHeight,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: getBoxDeco(8, greyColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          workerNameAndCreateDateWidget(worker),
          wokerDetailsBtnWidget(worker)
        ],
      ),
    );
  }

  //--Worker Name and Creation Date
  Widget workerNameAndCreateDateWidget(Users worker) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width / 1.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.7,
            child: Column(
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: AutoSizeText(
                      "${getText(context, "firstName")} : ${worker.firstName}",
                      style: getTextStyleAbel(18, blueColor),
                    )),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: AutoSizeText(
                      "${getText(context, "lastName")} : ${worker.lastName}",
                      style: getTextStyleAbel(18, blueColor),
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.7,
              child: AutoSizeText(
                "${getText(context, "startedWorkOn")} ${setupDateFromInputWithoutTimeWithSlach(worker.createdAt)}",
                style: getTextStyleAbel(18, blueColor),
              ))
        ],
      ),
    );
  }

  //---Worker Details Btn
  Widget wokerDetailsBtnWidget(Users worker) {
    return GestureDetector(
      onTap: (){
        //go to worker details Page
      },
      child: Container(
        width: 40,
        height: workerContainerHeight,
        decoration: getBoxDeco(8, blueColor),
        child: const Center(
          child: Icon(Icons.visibility_outlined,color: greyColor,),
        ),
      ),
    );
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
