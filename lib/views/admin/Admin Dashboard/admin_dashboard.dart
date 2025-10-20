import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_class.dart';
import '../../../services/providers/order_providers.dart';
import 'global_stats.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool isReady = false;
  List<GridData> listData = [];
  List<Order> recentOrdersDashboard = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      height: MediaQuery.of(context).size.height / 1.2,
      child: Column(
        children: [globalStatsWidget(), lastOrdersWidget()],
      ),
    );
  }

  Widget globalStatsWidget() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.1 - 10,
          child: Text(
            getText(context, "globalStats"),
            style: getTextStyleAbel(20, greyColor),
          ),
        ),
        mainGlobalStatsWidget(),
      ],
    );
  }

  Widget mainGlobalStatsWidget() {
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
      return globalStatsConsumer();
    }
  }

  Widget globalStatsConsumer() {
    return Consumer<OrdersProvider>(builder: (context, orderProvider, _) {
      listData = orderProvider.getGlobalStatsList();
      return GlobalStatsWidget(
        listData: listData,
      );
    });
  }

  Widget lastOrdersWidget() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1 - 10,
            child: Text(
              getText(context, "lastOrders"),
              style: getTextStyleAbel(20, greyColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer<OrdersProvider>(builder: (context, orderProvider, _) {
            recentOrdersDashboard = orderProvider.filterRecentOrders();
            if (recentOrdersDashboard.isEmpty) {
              return Container();
            }
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < recentOrdersDashboard.length; i++)
                      Column(
                        children: [
                          recentOrderWidget(recentOrdersDashboard.elementAt(i)),
                          const SizedBox(height: 10)
                        ],
                      )
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget recentOrderWidget(Order order) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: getBoxDeco(12, greyColor),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          orderIdandDetailsBtn(order),
          const SizedBox(
            height: 10,
          ),
          orderPriceAndStatus(order)
        ],
      ),
    );
  }

  Widget orderIdandDetailsBtn(Order order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.8,
          child: AutoSizeText(
            order.orderId,
            style: getTextStyleAbel(15, blueColor),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/3.5,
          decoration: getBoxDeco(8, blueColor),
          height: 50,
          child: Center(
            child: Text(
              getText(context, "seeDetails"),
              style: getTextStyleAbel(14, greyColor),
            ),
          ),
        )
      ],
    );
  }

  Widget orderPriceAndStatus(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/price.png",
                height: 35,
                width: 35,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "${double.parse(order.totalAmount.value).toStringAsFixed(2)} €",
                style: getTextStyleAbel(16, blueColor),
              )
            ],
          ),
          orderStatusWidget(order)
        ],
      ),
    );
  }

  Widget orderStatusWidget(Order order) {
    bool isCanceled = order.isCanceled!.value;
    bool isFinished = order.isFinished!.value;
    bool isStarted = order.isStarted!.value && !isFinished;
    bool notStarted = !isFinished && !isStarted;
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (notStarted)
          flagWidget(notStarted, getText(context, "notStarted"), redColor,
              greyColor, redColor),
        if (isStarted)
          flagWidget(isStarted, getText(context, "started"), greenColor2,
              greyColor, greenColor2),
        if (isFinished)
          flagWidget(isFinished, getText(context, "completed"), blueColor1,
              blueColor, blueColor1),
        if (isCanceled)
          flagWidget(isCanceled, getText(context, "canceled"), greyColor2,
              blueColor, blueColor)
      ],
    );
  }

  Widget flagWidget(bool isFlagActive, String flagText, Color flagBgColor,
      Color flagTextColor, Color borderColor) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width/3.5,
      //padding: const EdgeInsets.all(8),
      decoration: getBoxDecoWithBorder(8, flagBgColor, borderColor),
      child: Center(
        child: Text(
          flagText,
          style: getTextStyleAbel(12, flagTextColor),
        ),
      ),
    );
  }
}
