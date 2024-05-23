import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_func.dart';
import '../../../widgets/bottom_nav.dart';
import '../../../widgets/date_time_widget.dart';
import '../Order Management/worker_all_orders.dart';
import '../worker_vars.dart';
import 'worker_open_orders.dart';
import 'worker_tasks_day.dart';

var isWorkerHomeLoading = ValueNotifier(false);

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: isSmallScreen(context)
            ? BottomNavigation(
                navigateNavBarFn: navigateWorker,
                navigationOptions: workerHomeOptions,
                activeScreenNotifer: currentWorkerScreen,
              )
            : null,
        backgroundColor: bgColor,
        body: mainWorkerWidget());
  }

  Widget mainWorkerWidget() {
    switch (currentWorkerScreen.value) {
      case "W_H":
        return workerHomePageWidget();
      case "W_ORDERS_PAGE":
        return const WorkerAllOrdersPage();
      default:
        return workerHomePageWidget();
    }
  }

  Widget workerHomePageWidget() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                workerTopContainerHome(),
                const SizedBox(
                  height: 15,
                ),
                const Flexible(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      WorkerOpenOrders(),
                      SizedBox(
                        height: 5,
                      ),
                      WorkerTaksDay()
                    ],
                  ),
                ))
              ],
            ),
            loadingWidget(isWorkerHomeLoading)
          ],
        ));
  }

  Widget workerTopContainerHome() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/date.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 10,
              ),
              DateAndTimeWidget(
                myLang: currentFallBackFile.value,
              ),
            ],
          ),
          workerLogoWidget(),
        ],
      ),
    );
  }

  Widget workerLogoWidget() {
    return Image.asset(
      "assets/images/worker.png",
      height: 50,
      width: 50,
    );
  }

  //--Useful functions that uses the State
  void navigateWorker(int optionIndex) {
    String serviceQuickAccess =
        workerHomeOptions.elementAt(optionIndex).optionQuickAcess!;

    setState(() {
      currentWorkerScreen.value = serviceQuickAccess;
    });
  }
}
