import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/widgets/goBack_Btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../models/order_class.dart';
import '../../../services/providers/order_providers.dart';
import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';
import '../../../widgets/search_box.dart';
import '../worker_shared_func.dart';
import 'worker_order_details.dart';
import 'worker_orders_vars.dart';

List<Order> allOrdersWorker = [];

class WorkerAllOrdersPage extends StatefulWidget {
  const WorkerAllOrdersPage({super.key});

  @override
  State<WorkerAllOrdersPage> createState() => _WorkerAllOrdersPageState();
}

class _WorkerAllOrdersPageState extends State<WorkerAllOrdersPage> {
  TextEditingController searchController = TextEditingController();
  bool isReady = false;
  List<Order> allOrdersWorker = [];
  List<Order> currentOrdersWorker = [];
  double orderContainerHeight = 200;

  ValueNotifier orderSearchValue = ValueNotifier("");

  @override
  void initState() {
    setState(() {
      isOrderDetailsPressed.value = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ValueListenableBuilder(
            valueListenable: isOrderDetailsPressed,
            builder: (context, value, _) {
              if (isOrderDetailsPressed.value) {
                return detailsPage();
              }
              return allOrderMain();
            }));
  }

  Widget detailsPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(height: 40),
          workerAllPageTopContainer(),
          const SizedBox(height: 20),
          Expanded(
            child: WorderOrderDetails(
                order:
                    currentOrdersWorker.elementAt(currentOrderIdDetails.value)),
          ),
        ],
      ),
    );
  }

  Widget allOrderMain() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        workerAllPageTopContainer(),
        const SizedBox(
          height: 20,
        ),
        searchBoxAndOrderFilters(),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: allOrderMainWidget()),
      ],
    );
  }

  Widget allOrderMainWidget() {
    final allOrdersProvider =
        Provider.of<WorkerAllOrdersProvider>(context, listen: true);
    allOrdersProvider.getWorkerAllOrdersWithServices().then((value) {
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
      return openOrderListWidget();
    }
  }

  Widget openOrderListWidget() {
    return Consumer<WorkerAllOrdersProvider>(
        builder: (context, allOrderProvider, _) {
      allOrdersWorker = allOrderProvider.orderList;
      currentOrdersWorker = allOrdersWorker;
      currentOrdersWorker =
          allOrderProvider.filterOrdersWorker(orderSearchValue.value);
      if (allOrdersWorker.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: currentOrdersWorker.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    orderServiceWidget(currentOrdersWorker.elementAt(index)),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }

  Widget orderServiceWidget(Order order) {
    return Container(
      height: orderContainerHeight,
      decoration: getBoxDeco(12, blueColor),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [firstPartOrderWidget(order), startOrderButton(order)],
      ),
    );
  }

  Widget firstPartOrderWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.4,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          orderId(order),
          const SizedBox(
            height: 10,
          ),
          orderDuration(order),
          const SizedBox(
            height: 10,
          ),
          orderAppointment(order),
          const SizedBox(
            height: 10,
          ),
          orderStatusWidget(order),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget orderId(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.4,
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
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
              style: getTextStyleAbel(14, greyColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget orderDuration(Order order) {
    String orderDuration = getOrderDuration(order);
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
          style: getTextStyleAbel(14, greyColor),
        )
      ],
    );
  }

  Widget orderAppointment(Order order) {
    String orderAppoitnment = setupDateFromInput(order.appointmentDate.value);
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          "assets/images/date.png",
          height: 30,
          width: 30,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          orderAppoitnment,
          style: getTextStyleAbel(15, greyColor),
        )
      ],
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
    return Row(
      children: [
        Container(
          //height: 40,
          padding: const EdgeInsets.all(8),
          decoration: getBoxDecoWithBorder(8, flagBgColor, borderColor),
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

  Widget startOrderButton(Order order) {
    bool isStarted = order.isStarted!.value;
    bool isFinished = order.isFinished!.value;
    bool isCanceled = order.isCanceled!.value;

    bool availableForFix = !isStarted && !isFinished && !isCanceled;
    String buttonAsset = availableForFix
        ? "assets/images/fix_now.png"
        : "assets/images/look.png";
    return GestureDetector(
      onTap: () {
        setState(() {
          currentOrderIdDetails.value = currentOrdersWorker
              .indexWhere((element) => element.orderId == order.orderId);
          isOrderDetailsPressed.value = true;
        });
      },
      child: Container(
        height: orderContainerHeight,
        width: 50,
        decoration: getBoxDeco(12, greyColor2),
        child: Center(
            child: Image.asset(
          buttonAsset,
          height: 40,
          width: 40,
        )),
      ),
    );
  }

  Widget workerAllPageTopContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        children: [
          GoBackButton(callBack: goBackWorkerOrderPage),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                getText(context, "orderDashboard").toUpperCase(),
                style: getTextStyleAbel(22, greyColor),
              ),
            ),
          ),
          scanOrderQrCodeBtn()
        ],
      ),
    );
  }

  Widget searchBoxAndOrderFilters() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchBox(
            hintText: '',
            controller: searchController,
            onChanged: (String value) {
              setState(() {
                orderSearchValue.value = value;
              });
            },
            boxWidth: MediaQuery.of(context).size.width / 1.3,
          ),
          filterOrdersBtn()
        ],
      ),
    );
  }

  Widget filterOrdersBtn() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        width: 50,
        decoration: getBoxDeco(12, greyColor2),
        child: Center(
            child: Image.asset(
          "assets/images/filter.png",
          height: 30,
          width: 30,
        )),
      ),
    );
  }

  Widget scanOrderQrCodeBtn() {
    return GestureDetector(
      child: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: Image.asset(
            "assets/images/qr-code.png",
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  }

  //-------------------Function that uses the State --------------------------------
  void goBackWorkerOrderPage() {
    if (isOrderDetailsPressed.value) {
      setState(() {
        isOrderDetailsPressed.value = false;
      });
    } else {
      setState(() {});
    }
  }
}
