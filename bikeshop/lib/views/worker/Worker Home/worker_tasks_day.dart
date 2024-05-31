import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order_class.dart';
import '../../../services/providers/order_providers.dart';
import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';
import '../worker_shared_func.dart';

class WorkerTaksDay extends StatefulWidget {
  const WorkerTaksDay({super.key});

  @override
  State<WorkerTaksDay> createState() => _WorkerTaksDayState();
}

class _WorkerTaksDayState extends State<WorkerTaksDay> {
  List<Order> ordersOfDay = [];
  bool isReady = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1,
      child: Column(
        children: [
          workerTasksOfDayWidget(),
          const SizedBox(
            height: 5,
          ),
          workerTasksDayMainWidget()
        ],
      ),
    );
  }

  Widget workerTasksDayMainWidget() {
    final ordersProvider =
        Provider.of<WorkerAllOrdersProvider>(context, listen: true);
    ordersProvider.getWorkerAllOrdersWithServices().then((value) {
      isReady = true;
    }).onError((error, stackTrace) {
      isReady = true;
    });
    if (!isReady) {
      return Container(
        //height: MediaQuery.of(context).size.height / 4,
        color: bgColor.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    } else {
      return ordersDayListWidget();
    }
  }

  Widget ordersDayListWidget() {
    return Consumer<WorkerAllOrdersProvider>(
        builder: (context, openOrderProvider, _) {
      ordersOfDay = openOrderProvider.orderList;
      ordersOfDay = openOrderProvider.filterOrdersWorkerToday();
      if (ordersOfDay.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        //height: MediaQuery.of(context).size.height / 4,
        child: Column(
          children: [
            for (int i = 0; i < ordersOfDay.length; i++)
              Column(
                children: [
                  orderOfDayWidget(ordersOfDay.elementAt(i)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
          ],
        ),
      );
    });
  }

  Widget orderOfDayWidget(Order orderDay) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: getBoxDeco(8, greyColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            orderIdAndNumberServicesWidget(orderDay),
            const SizedBox(
              height: 10,
            ),
            appointmentAndDurationWidget(orderDay),
            const SizedBox(
              height: 10,
            ),
            startOrderNowButton(orderDay),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget orderIdAndNumberServicesWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [orderId(order), serviceNumberWidget(order)],
      ),
    );
  }

  Widget orderId(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.9,
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text("${getText(context, "orderId")} : ",
                  style: getTextStyleAbel(14, blueColor))),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.8,
            child: AutoSizeText(
              order.orderId.toString(),
              style: getTextStyleAbel(14, blueColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceNumberWidget(Order order) {
    return Column(
      children: [
        Text(
          getText(context, "services"),
          style: getTextStyleAbel(14, blueColor),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: 40,
          width: 40,
          decoration: getBoxDeco(5, blueColor),
          child: Center(
            child: Text(
              order.serviceCount!.toString(),
              style: getTextStyleAbel(15, greyColor),
            ),
          ),
        )
      ],
    );
  }

  Widget workerTasksOfDayWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Text(
        getText(context, "todaysTasks"),
        style: getTextStyleAbel(20, greyColor),
      ),
    );
  }

  Widget appointmentAndDurationWidget(Order orderDay) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [orderAppointmentWidget(orderDay),orderDurationWidget(orderDay)],
      ),
    );
  }

  Widget orderDurationWidget(Order orderDay) {
    String orderDuration = getOrderDuration(orderDay);
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          "assets/images/duration.png",
          height: 35,
          width: 35,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          orderDuration,
          style: getTextStyleAbel(14, blueColor),
        )
      ],
    );
  }

  Widget orderAppointmentWidget(Order orderDay) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width / 3,
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
            "${getText(context, "today")} ${setupTimeFromInputWithoutDate(orderDay.appointmentDate.value)}",
            style: getTextStyleAbel(15, blueColor),
          )
        ],
      ),
    );
  }

  Widget startOrderNowButton(Order orderDay) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 1.4,
        decoration: getBoxDeco(5, greenColor),
        child: Center(
          child: Text(
            getText(context, "startNow"),
            style: getTextStyleAbel(15, greyColor),
          ),
        ),
      ),
    );
  }
}
