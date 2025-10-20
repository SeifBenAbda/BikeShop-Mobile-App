import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../models/order_class.dart';
import '../../../services/order_service.dart';
import '../../../services/providers/order_providers.dart';
import '../../../utils/Global Folder/glaobal_vars.dart';
import '../../../utils/Global Folder/global_func.dart';
import '../worker_shared_func.dart';
import 'worker_orders_vars.dart';
import 'worker_parts_change.dart';

class WorderOrderDetails extends StatefulWidget {
  final Order order;
  const WorderOrderDetails({super.key, required this.order});

  @override
  State<WorderOrderDetails> createState() => _WorderOrderDetailsState();
}

class _WorderOrderDetailsState extends State<WorderOrderDetails> {
  var isLoadingOrderDetails = ValueNotifier(false);
  @override
  void initState() {
    widget.order.orderedServices.value.forEach((element) {
      element.isFinished ??= ValueNotifier(false);
    });
    workerCommentsController.text = widget.order.workerComments!.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.05,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: Column(
              children: [
                orderDetailsWidget(widget.order), // This widget is fixed
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        servicesListWidget(widget.order),
                        const SizedBox(height: 10),
                        sepeartor(),
                        const SizedBox(height: 10),
                        clientNotesWidget(widget.order),
                        const SizedBox(height: 10),
                        workerNotesWidget(widget.order),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          loadingWidget(isLoadingOrderDetails)
        ],
      ),
    );
  }

  //-- Order Details Widget

  Widget orderDetailsWidget(Order order) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.08,
      decoration: getBoxDeco(12, greyColor2),
      padding: const EdgeInsets.all(4),
      //height: 100,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          orderIdWidget(order),
          const SizedBox(
            height: 10,
          ),
          orderDurationAndStatus(order),
          const SizedBox(
            height: 20,
          ),
          startUpdateOrderBtn(order),
        ],
      ),
    );
  }

  Widget orderIdWidget(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.6,
        child: AutoSizeText(
          order.orderId,
          style: getTextStyleAbel(18, blueColor),
        ),
      ),
    );
  }

  Widget orderDurationAndStatus(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [orderDurationWidget(order), orderStatusWidget(order)],
      ),
    );
  }

  Widget orderDurationWidget(Order order) {
    String orderDuration = getOrderDuration(order);
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.5,
      child: Row(
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
            style: getTextStyleAbel(18, blueColor),
          )
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

  Widget startUpdateOrderBtn(Order order) {
    bool isCanceled = order.isCanceled!.value;
    bool isFinished = order.isFinished!.value;
    
    if (!isCanceled && !isFinished) {
      return ValueListenableBuilder(
          valueListenable: order.isStarted!,
          builder: (context, value, _) {
            bool isStarted = order.isStarted!.value && !isFinished;
            bool notStarted = !isFinished && !isStarted;
          
            return GestureDetector(
              onTap: () {
                if (notStarted) {
                  startFinishOrderFn(order, notStarted);
                } else {
                  updateNotesOrder(order);
                }
              },
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width / 1.3,
                decoration: notStarted
                    ? getBoxDeco(8, greenColor2)
                    : getBoxDeco(8, blueColor),
                child: Center(
                  child: Text(
                      notStarted
                          ? getText(context, "startNow")
                          : getText(context, "updateNotes"),
                      style: getTextStyleAbel(16, greyColor)),
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }

  Widget updateOrderButton(Order order) {
    bool isCanceled = order.isCanceled!.value;
    bool isFinished = order.isFinished!.value;
    bool isStarted = order.isStarted!.value && !isFinished;

    if (!isCanceled && !isFinished && isStarted) {
      return Container(
        height: 45,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: getBoxDeco(8, blueColor),
        child: Center(
            child: Text(
          getText(context, "updateNotes"),
          style: getTextStyleAbel(17, greyColor),
        )),
      );
    } else {
      return Container();
    }
  }

  //-- --------------------End of Top Container --------------------------------

  Widget servicesListWidget(Order order) {
    return Column(
      children: [
        servicesNumber(order),
        const SizedBox(
          height: 10,
        ),
        listOfServicesWidget(order),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget servicesNumber(Order order) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  getText(context, "services"),
                  style: getTextStyleAbel(22, greyColor),
                ),
                /*const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: getBoxDeco(8, greyColor2),
                  child: Center(
                    child: Text(
                      "${order.orderedServices.value.length}",
                      style: getTextStyleAbel(20, blueColor),
                    ),
                  ),
                )*/
              ],
            ),
            changeItemsInOrderBtn(order)
          ],
        ));
  }

  //this opens Diaoge with Items and Request
  Widget changeItemsInOrderBtn(Order order) {
    return GestureDetector(
      onTap: () {
        if (order.isStarted!.value == true && !order.isFinished!.value) {
          showDialoge();
        } else {
          showError(
              context,
              order.isFinished!.value
                  ? getText(context, "orderClosed")
                  : getText(context, "startOrderFirst"));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        height: 40,
        decoration: getBoxDeco(8, greyColor2),
        child: Center(
          child: Text(
            getText(context, "changeParts"),
            style: getTextStyleAbel(14, blueColor),
          ),
        ),
      ),
    );
  }

  Widget listOfServicesWidget(Order order) {
    return Column(
      children: [
        for (int i = 0; i < order.orderedServices.value.length; i++)
          Column(
            children: [
              orderServiceDetailWidget(
                  order.orderedServices.value.elementAt(i), order),
              const SizedBox(
                height: 10,
              ),
            ],
          )
      ],
    );
  }

  Widget orderServiceDetailWidget(ShopService orderService, Order order) {
    String serviceName = currentFallBackFile.value == "en"
        ? orderService.serviceName
        : orderService.serviceNameGerman;

    return GestureDetector(
      onDoubleTap: () {
        if (order.isStarted!.value == true && !order.isFinished!.value) {
          setState(() {
            orderService.isFinished =
                ValueNotifier(!orderService.isFinished!.value);
          });
        } else {
          showError(
              context,
              order.isFinished!.value
                  ? getText(context, "orderClosed")
                  : getText(context, "startOrderFirst"));
        }
      },
      child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 1.13,
          decoration: getBoxDeco(5, greyColor),
          child: ValueListenableBuilder(
              valueListenable: orderService.isFinished!,
              builder: (context, value, _) {
                if (orderService.isFinished!.value == true) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.6,
                        child: AutoSizeText(
                          serviceName,
                          style: getTextStyleAbel(20, blueColor),
                        ),
                      ),
                      Image.asset(
                        "assets/images/accept.png",
                        height: 35,
                        width: 35,
                      )
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: AutoSizeText(
                        serviceName,
                        style: getTextStyleAbel(20, blueColor),
                      ),
                    ),
                    Image.asset(
                      "assets/images/error.png",
                      height: 35,
                      width: 35,
                    )
                  ],
                );
              })),
    );
  }

  Widget serviceState(ShopService service) {
    return ValueListenableBuilder(
        valueListenable: service.isFinished!,
        builder: (context, value, _) {
          if (service.isFinished!.value) {
            return Image.asset(
              "assets/images/accept.png",
              height: 35,
              width: 35,
            );
          }
          return Image.asset(
            "assets/images/error.png",
            height: 35,
            width: 35,
          );
        });
  }

  //Sepeartor
  Widget sepeartor() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width / 1.1,
      color: greyColor,
    );
  }

  //----Client Notes
  Widget clientNotesWidget(Order order) {
    final allOrdersProvider =
        Provider.of<WorkerAllOrdersProvider>(context, listen: true);

    allOrdersProvider.getWorkerAllOrdersWithServices().then((value) {
      int orderIndex =
          value.indexWhere((element) => element.orderId == order.orderId);
      order = value.elementAt(orderIndex);
    });

    String clientNotes = order.orderComment.text == ""
        ? getText(context, "notesUnavailable")
        : order.orderComment.text;
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Text(
                getText(context, "clientNotes"),
                style: getTextStyleAbel(22, greyColor),
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: getBoxDeco(8, blueColor),
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: AutoSizeText(
                clientNotes,
                style: getTextStyleAbel(17, greyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //---Worker Notes
  Widget workerNotesWidget(Order order) {
    return SizedBox(
      width: 90.w,
      child: Column(
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              getText(context, "myNotes"),
              style: getTextStyleAbel(22, greyColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: getBoxDeco(10, optionConColor),
            width: 90.w,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextFormField(
                enabled: !order.isFinished!.value,
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.text,
                controller: workerCommentsController,
                //initialValue: order.workerComments!.value,
                autofocus: false,
                style: getTextStyleWhiteFjallone(15),
                cursorColor: cursorTextFieldColor3,
                onChanged: (value) {
                  setState(() {
                    workerCommentsController.text = value;
                  });
                },
                decoration: InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: getText(context, "myNotes"),
                    hintStyle: getTextStyleWhiteFjallone(15),
                    suffixIcon: IconButton(
                        onPressed: () {
                          workerCommentsController.text = "";
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 20,
                        ))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //---- Useful Functions----------------------//
  void startFinishOrderFn(Order order, bool isStarted) async {
    isLoadingOrder(true);
    order.workerComments!.value = workerCommentsController.text == ""
        ? order.workerComments!.value
        : workerCommentsController.text;
    OrderService os = OrderService();
    await setupStartAndEndTimeOfOrder(order, isStarted).then(((value) async {
      await os.updateOrderToServer(order).then((value) {
        isLoadingOrder(false);
      });
    }));
  }

  void updateNotesOrder(Order order) async {
    isLoadingOrder(true);
    order.workerComments!.value = workerCommentsController.text == ""
        ? order.workerComments!.value
        : workerCommentsController.text;
    OrderService os = OrderService();
    await os.updateOrderToServer(order).then((value) {
      isLoadingOrder(false);
      showSucess(context, getText(context, "notesUpdatedSuccess"));
    });
  }

  void isLoadingOrder(bool isLoading) {
    setState(() {
      isLoadingOrderDetails.value = isLoading;
    });
  }

  Future<void> setupStartAndEndTimeOfOrder(Order order, bool isStarted) async {
    DateTime? currentStartedTime = order.startedAt;
    if (isStarted) {
      print("I am Starting");
      setState(() {
        order.isStarted!.value = true;
        order.isFinished!.value = false;
        order.startedAt = DateTime.now();
        order.finishedAt = null;
      });
    } else {
      print("I am Updating");
      setState(() {
        order.isFinished!.value = true;
        order.finishedAt = DateTime.now();
        order.startedAt = currentStartedTime;
      });
    }
  }

  void showDialoge() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        builder: (context) {
          return WorkerOrderPartsChange(
            order: widget.order,
          );
        });
  }
}
