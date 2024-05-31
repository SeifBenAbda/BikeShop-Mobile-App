import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_class.dart';
import '../../../services/providers/order_providers.dart';
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
  bool isReady = false;
  List<Order> allOrders = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:true , 
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
                openOrderAndDayTasksWidget()
              ],
            ),
            loadingWidget(isWorkerHomeLoading)
          ],
        ));
  }

  Widget openOrderAndDayTasksWidget() {
    final openOrdersProvider =
        Provider.of<OrdersProvider>(context, listen: true);
    openOrdersProvider.getAllOrdersDetailled().then((value) {
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
      return openOrdersTasksDayConsumer();
    }
  }

  Widget openOrdersTasksDayConsumer() {
    return Consumer<OrdersProvider>(builder: (context, allOrdersProvider, _) {
      allOrders = allOrdersProvider.myOrdersList;
      if (allOrders.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return const Flexible(
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
      ));
    });
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
