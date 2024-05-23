import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/services/order_service.dart';
import 'package:bikeshop/services/providers/clientOrders_provider.dart';
import 'package:bikeshop/views/client/Order%20Tracking/order_details_client.dart';
import 'package:bikeshop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_class.dart';
import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';
import '../../../widgets/goBack_Btn.dart';

class OrderTrackingClient extends StatefulWidget {
  const OrderTrackingClient({super.key});

  @override
  State<OrderTrackingClient> createState() => _OrderTrackingClientState();
}

class _OrderTrackingClientState extends State<OrderTrackingClient> {
  var isOrdersLoading = ValueNotifier(false);
  var isOrderDetailsPressed = ValueNotifier(false);
  var orderDetailIndex = ValueNotifier(-1);
  double orderContainerHeight = 210;
  List<Order> ordersList = [];
  bool isReady = false;
  @override
  void initState() {
    super.initState();
    //getClientOrders();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [mainOrdersWidget(), loadingWidget(isOrdersLoading)],
        ));
  }

  //-- Main Orders Widget-------------//
  Widget mainOrdersWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        topContainerTrackOrders(),
        const SizedBox(
          height: 30,
        ),
        ValueListenableBuilder(
            valueListenable: isOrderDetailsPressed,
            builder: (context, value, _) {
              if (isOrderDetailsPressed.value) {
                return const OrderDetailsClient();
              }
              return mainOrderTrackingWidget();
            })
      ],
    );
  }

  //----- List of Orders----------------------------//

  Widget mainOrderTrackingWidget() {
    final clientOrdersProvider =
        Provider.of<ClientOrdersProvider>(context, listen: true);
    clientOrdersProvider.getClientOrders().then((value) {
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
      return Expanded(child: listOfOrdersWidget());
    }
  }

  Widget listOfOrdersWidget() {
    return Consumer<ClientOrdersProvider>(
        builder: (context, clientOrdersProvider, _) {
      ordersList = clientOrdersProvider.clientOrders;
      if (ordersList.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < ordersList.length; i++) orderBigContainer(i)
              ],
            ),
          ),
        ),
      );
    });
  }

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
                  seeOrderDetailsBtn()
                ],
              )),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget seeOrderDetailsBtn() {
    return GestureDetector(
      onTap: () {},
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
    return AutoSizeText(
      ordersList.elementAt(orderIndex).orderId,
      style: getTextStyleAbel(16, blueColor),
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

  //-----Top Container Track Orders Page -------------------//
  Widget topContainerTrackOrders() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      //height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GoBackButton(
            callBack: trackOrderReturnFunc,
          ),

          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                getText(context, "myOrders").toUpperCase(),
                style: getTextStyleAbel(22, greyColor),
              ),
            ),
          ),
          // const Spacer()
        ],
      ),
    );
  }

  //---Functions that use state

  void getClientOrders() async {
    OrderService os = OrderService();
    setLoadingOrders(true);
    await os.getUserOrdersWithServiceCount().then((listOfOrders) {
      setState(() {
        ordersList = listOfOrders;
      });
      setLoadingOrders(false);
    });
  }

  void setLoadingOrders(bool value) {
    isOrdersLoading.value = value;
  }

  void trackOrderReturnFunc() {
    if (isOrderDetailsPressed.value) {
      goBackFromOrderDetails();
    } else {
      goHomePageClient();
    }
  }

  void goBackFromOrderDetails() {
    setState(() {
      isOrderDetailsPressed.value = false;
    });
  }
}
