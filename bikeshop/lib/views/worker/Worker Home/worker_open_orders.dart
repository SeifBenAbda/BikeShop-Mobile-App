import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/services/order_service.dart';
import 'package:bikeshop/services/providers/order_providers.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_class.dart';
import '../../../widgets/ItemsSliderWidget.dart';
import 'worker_home_page.dart';

class WorkerOpenOrders extends StatefulWidget {
  const WorkerOpenOrders({super.key});

  @override
  State<WorkerOpenOrders> createState() => _WorkerOpenOrdersState();
}

class _WorkerOpenOrdersState extends State<WorkerOpenOrders> {
  List<Order> openedOrders = [];
  bool isReady = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          workerOpenOrdersWidget(),
          const SizedBox(
            height: 10,
          ),
          openOrderListWidget(),
        ],
      ),
    );
  }

  Widget seperator() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width / 1.1,
      color: greyColor,
    );
  }

  Widget workerOpenOrdersWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Text(
        getText(context, "openOrders"),
        style: getTextStyleAbel(20, greyColor),
      ),
    );
  }

  Widget openOrderListWidget() {
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
      return openOrdersConsumer();
    }
    
  }

  Widget openOrdersConsumer(){
    return Consumer<OrdersProvider>(builder: (context, openOrderProvider, _) {
      openedOrders = openOrderProvider.myOrdersList;
      openedOrders = openOrderProvider.filterOpenedOrders();
      if (openedOrders.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return ListSlider(
        list: openedOrders,
        slidingWidget: openOrderWidget,
        sliderContentWidth: MediaQuery.of(context).size.width / 1.3,
        sliderContentHeight: 200,
      );
    });
  }

  Widget openOrderWidget(int openedOrderIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          padding: const EdgeInsets.all(8),
          decoration: getBoxDeco(15, blueColor),
          child: Column(
            children: [
              orderIdAndNumberOfServices(openedOrderIndex),
              const SizedBox(
                height: 10,
              ),
              appointementDate(openedOrderIndex),
              const SizedBox(
                height: 15,
              ),
              addToWorkerTasksButton(openedOrderIndex),
              const SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }

  Widget orderIdAndNumberOfServices(int openedOrderIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2.4,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("${getText(context, "orderId")} : ",
                      style: getTextStyleAbel(14, greyColor))),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.8,
                child: AutoSizeText(
                  openedOrders.elementAt(openedOrderIndex).orderId.toString(),
                  style: getTextStyleAbel(14, greyColor),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              getText(context, "services"),
              style: getTextStyleAbel(14, greyColor),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: getBoxDeco(8, greyColor),
              child: Center(
                child: Text(
                  openedOrders
                      .elementAt(openedOrderIndex)
                      .serviceCount!
                      .toString(),
                  style: getTextStyleAbel(15, blueColor),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget appointementDate(int openedOrderIndex) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        children: [
          Image.asset(
            "assets/images/date.png",
            height: 30,
            width: 30,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            setupDateFromInput(
                openedOrders.elementAt(openedOrderIndex).appointmentDate.value),
            style: getTextStyleAbel(15, greyColor),
          )
        ],
      ),
    );
  }

  Widget addToWorkerTasksButton(int openedOrderIndex) {
    return GestureDetector(
      onTap: () {
        setupOrderToWorker(openedOrderIndex);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.7,
        height: 30,
        decoration: getBoxDeco(5, greyColor),
        child: Center(
          child: Text(
            getText(context, "addToMyTasks"),
            style: getTextStyleAbel(10, blueColor),
          ),
        ),
      ),
    );
  }

  //---Functions that uses the State
  void setWorkerHomeLoading(bool value) {
    setState(() {
      isWorkerHomeLoading.value = value;
    });
  }

  void setupOrderToWorker(int openedOrderIndex) async {
    Order order = openedOrders.elementAt(openedOrderIndex);
    setWorkerHomeLoading(true);
    OrderService os = OrderService();

    await os.assignOrderToWorker(order).then((value) {
      setWorkerHomeLoading(false);
    });
  }
}
