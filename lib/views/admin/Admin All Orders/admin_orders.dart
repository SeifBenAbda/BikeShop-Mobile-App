import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_class.dart';
import '../../../services/providers/order_providers.dart';
import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';

class AdminOrdersPage extends StatefulWidget {
  final VoidCallback toggleDrawer;
  const AdminOrdersPage({super.key, required this.toggleDrawer});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  bool isReady = false;
  double orderContainerHeight = 210;
  List<Order> ordersList = [];
  dynamic currentOrderSlected;
  var isOrderDetailsPressed = ValueNotifier(false);
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
          Expanded(child: mainAdminAllOrdersWidget())
          ],
      ),
    );
  }

  Widget adminOrdersTopContainer() {
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

  //--- All Orders Listener
  Widget mainAdminAllOrdersWidget() {
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
      return allOrdersConsumer();
    }
  }


  //--- All Orders Consumer
  Widget allOrdersConsumer() {
    return Consumer<OrdersProvider>(builder: (context, orderProvider, _) {
      ordersList = orderProvider.myOrdersList;
      return SingleChildScrollView(
        child: Column(
          children: [
            for(int orderIndex = 0; orderIndex < ordersList.length; orderIndex++)
              Column(
                children: [
                  orderBigContainer(orderIndex)
                ],
              )
          ],
        ),
      );
    });
  }


  //---- Order Widget With Details
  Widget orderBigContainer(int orderIndex) {
    return SizedBox(
      height: orderContainerHeight,
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: [
          Container(
              decoration: getBoxDeco(12, greyColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  firstPartContainer(orderIndex),
                  seeOrderDetailsBtn(orderIndex)
                ],
              )),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget seeOrderDetailsBtn(int orderIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentOrderSlected = ordersList.elementAt(orderIndex);
          isOrderDetailsPressed.value = true;
        });
      },
      child: Container(
        decoration: getBoxDeco(12, blueColor),
        width: 50,
        height: orderContainerHeight - 20,
        child: const Center(
          child: Icon(
            Icons.visibility_outlined,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget firstPartContainer(orderIndex) {
    return SizedBox(
      height: orderContainerHeight - 20,
      width: MediaQuery.of(context).size.width / 1.1 - 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            orderIdWidget(orderIndex),
            const Spacer(),
            orderAppointmentWidget(orderIndex),
            orderAmountWidget(orderIndex),
            const Spacer(),
            orderStatusWidget(orderIndex),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget orderIdWidget(int orderIndex) {
    return Row(
      children: [
        Image.asset("assets/images/order.png",height: 35,width: 35,),
        const SizedBox(width: 10,),
        SizedBox(
          width: MediaQuery.of(context).size.width/1.8,
          child: AutoSizeText(
            ordersList.elementAt(orderIndex).orderId,
            style: getTextStyleAbel(16, blueColor),
          ),
        ),
      ],
    );
  }

  Widget orderAppointmentWidget(int orderIndex) {
    bool isCanceled = ordersList.elementAt(orderIndex).isCanceled!.value;
    return !isCanceled
        ? Column(
            children: [
              Row(
                children: [
                  Text(
                    "${getText(context, "appointment")} : ",
                    style: getTextStyleAbel(16, blueColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  AutoSizeText(
                    setupDateFromInput(
                        ordersList.elementAt(orderIndex).appointmentDate.value),
                    style: getTextStyleAbel(16, blueColor),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )
        : Container();
  }

  Widget orderAmountWidget(int orderIndex) {
    return Row(
      children: [
        Image.asset(
          "assets/images/price.png",
          height: 25,
          width: 25,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${getText(context, "totalPrice")} : ",
          style: getTextStyleAbel(16, blueColor),
        ),
        const SizedBox(
          width: 5,
        ),
        AutoSizeText(
          "${double.parse(ordersList.elementAt(orderIndex).totalAmount.value).toStringAsFixed(2)} €",
          style: getTextStyleAbel(16, blueColor),
        )
      ],
    );
  }

  Widget orderStatusWidget(int orderIndex) {
    bool isCanceled = ordersList.elementAt(orderIndex).isCanceled!.value;
    bool isFinished = ordersList.elementAt(orderIndex).isFinished!.value;
    bool isStarted =
        ordersList.elementAt(orderIndex).isStarted!.value && !isFinished;
    bool notStarted = !isFinished && !isStarted;
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (notStarted)
          flagWidget(notStarted, getText(context, "notStarted"), redColor,
              greyColor, redColor),
        if (isStarted)
          flagWidget(isStarted, getText(context, "started"), greenColor,
              greyColor, Colors.white),
        if (isFinished)
          flagWidget(isFinished, getText(context, "completed"), blueColor,
              greyColor, Colors.white),
        if (isCanceled)
          flagWidget(isCanceled, getText(context, "canceled"), greyColor2,
              blueColor, blueColor)
      ],
    );
  }

  Widget flagWidget(bool isFlagActive, String flagText, Color flagBgColor,
      Color flagTextColor, Color borderColor) {
    return Row(
      children: [
        Container(
          //height: 40,
          padding: const EdgeInsets.all(8),
          decoration: getBoxDecoWithBorder(15, flagBgColor, borderColor),
          child: Center(
            child: Text(
              flagText,
              style: getTextStyleAbel(12, flagTextColor),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }



  //----------

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
