import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:provider/provider.dart';
import '../../../models/order_class.dart';
import '../../../services/providers/clientOrders_provider.dart';
import 'order_tracking_item_change.dart';
import 'order_tracking_notes.dart';
import 'order_tracking_vars.dart';

class OrderDetailsClient extends StatefulWidget {
  final Order order;
  const OrderDetailsClient({super.key, required this.order});

  @override
  State<OrderDetailsClient> createState() => _OrderDetailsClientState();
}

class _OrderDetailsClientState extends State<OrderDetailsClient> {
  bool isReady = false;
  @override
  Widget build(BuildContext context) {
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
      return Consumer<ClientOrdersProvider>(
        builder: (context, clientOrdersProvider, _) {
      Order myOrder = clientOrdersProvider.clientOrders.where((order) => order.orderId==widget.order.orderId).first;
      return Expanded(
        child: Column(
          children: [
            orderDetailsTopContainer(myOrder),
            const SizedBox(height: 10),
            Expanded(child: tabWidget(myOrder))
          ],
        ),
      );
    });
      
    }
  }

  //----------------Oder Details Top Container----------------

  Widget orderDetailsTopContainer(Order order) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.05,
      decoration: getBoxDeco(12, greyColor),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          orderIdWidget(order),
          const SizedBox(
            height: 10,
          ),
          orderDayWidget(order),
          const SizedBox(
            height: 10,
          ),
          orderAppointmentWidget(order),
          const SizedBox(
            height: 10,
          ),
          orderPriceAndStatus(order)
        ],
      ),
    );
  }

  Widget orderIdWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/order.png",
                height: 35,
                width: 35,
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: AutoSizeText(
                    order.orderId,
                    style: getTextStyleAbel(16, blueColor),
                  )),
            ],
          ),
          qrCodeScannerWidget(order)
        ],
      ),
    );
  }

  Widget qrCodeScannerWidget(Order order) {
    return SizedBox(
      child: Center(
        child: Image.asset(
          "assets/images/qr-code.png",
          height: 45,
          width: 45,
        ),
      ),
    );
  }

  Widget orderDayWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        children: [
          Image.asset(
            "assets/images/day.png",
            height: 35,
            width: 35,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "${getText(context, "orderDay")} : ${setupDateFromInput(order.orderDate!.value)}",
            style: getTextStyleAbel(16, blueColor),
          )
        ],
      ),
    );
  }

  Widget orderAppointmentWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/date.png",
                height: 35,
                width: 35,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "${getText(context, "appointmentDayTime")} : ",
                style: getTextStyleAbel(16, blueColor),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.7,
            child: Text(
              setupDateFromInput(order.appointmentDate.value),
              style: getTextStyleAbel(16, blueColor),
            ),
          )
        ],
      ),
    );
  }

  Widget orderPriceAndStatus(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
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
        const SizedBox(
          width: 10,
        ),
        if (notStarted)
          flagWidget(notStarted, getText(context, "notStarted"), redColor,
              greyColor, redColor),
        if (isStarted)
          flagWidget(isStarted, getText(context, "started"), greenColor2,
              greyColor, greenColor2),
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
    return Container(
      //height: 40,
      padding: const EdgeInsets.all(8),
      decoration: getBoxDecoWithBorder(8, flagBgColor, borderColor),
      child: Center(
        child: Text(
          flagText,
          style: getTextStyleAbel(12, flagTextColor),
        ),
      ),
    );
  }

  //-----------------Tabulation Part Between Services  + Client and Worker Notes + Requestes Item Chanages-----//

  Widget tabWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.05,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            ButtonsTabBar(
                height: 50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                backgroundColor: blueColor,
                unselectedBackgroundColor: greyColor2,
                unselectedLabelStyle: getTextStyleAbel(20, blueColor),
                labelStyle: getTextStyleAbel(20, greyColor),
                tabs: getTabsWidget(context)),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  listOfServices(order),
                  OrderTrackerNotes(
                    order: order,
                  ),
                  OrderTrackingItemChange(order: order,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //List of Ordered Services
  Widget listOfServices(Order order) {
    return Column(
      children: [
        for (int i = 0; i < order.orderedServices.value.length; i++)
          Column(
            children: [
              orderServiceWidget(order.orderedServices.value.elementAt(i)),
              const SizedBox(
                height: 10,
              )
            ],
          )
      ],
    );
  }

  Widget orderServiceWidget(ShopService service) {
    bool isGerman = currentFallBackFile.value == "de";
    return Container(
        //height: 50,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: getBoxDeco(12, greyColor),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              "assets/images/${service.serviceImage}",
              height: 40,
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: AutoSizeText(
                  isGerman ? service.serviceNameGerman : service.serviceName,
                  style: getTextStyleAbel(18, blueColor),
                )),
          ],
        ));
  }
}
