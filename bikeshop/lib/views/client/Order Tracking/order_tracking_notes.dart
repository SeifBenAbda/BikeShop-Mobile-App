import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/services/order_service.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/order_class.dart';
import '../../../services/providers/clientOrders_provider.dart';
import '../../../utils/Global Folder/global_deco.dart';
import 'order_tracking_vars.dart';

class OrderTrackerNotes extends StatefulWidget {
  final Order order;
  const OrderTrackerNotes({super.key, required this.order});

  @override
  State<OrderTrackerNotes> createState() => _OrderTrackerNotesState();
}

class _OrderTrackerNotesState extends State<OrderTrackerNotes> {
  bool isReady = false;
  var isLoadingUpdateComments = ValueNotifier(false);
  @override
  void initState() {
    clientOrderCommentsController.text = widget.order.orderComment.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mainOrderTrackingNotes(),
        loadingWidget(isLoadingUpdateComments)
      ],
    );
  }

  Widget mainOrderTrackingNotes() {
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
        Order myOrder = clientOrdersProvider.clientOrders
            .where((order) => order.orderId == widget.order.orderId)
            .first;
        return SingleChildScrollView(
            child: Column(
              children: [
                workerNotesWidget(myOrder),
                const SizedBox(
                  height: 10,
                ),
                clientNotesWidget(myOrder),
                const SizedBox(
                  height: 20,
                ),
                updateNotesBtnWidget(myOrder)
              ],
            ),
          
        );
      });
    }
  }

  //------------Widget worker Notes------------

  Widget workerNotesWidget(Order order) {
    return ValueListenableBuilder(
        valueListenable: order.workerComments!,
        builder: (context, value, _) {
          return Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Column(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Text(
                        getText(context, "workerNotes"),
                        style: getTextStyleAbel(20, greyColor),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.05,
                    decoration: getBoxDeco(8, greyColor2),
                    padding: const EdgeInsets.all(8),
                    child: AutoSizeText(
                      order.workerComments!.value=="null"?getText(context, "notesUnavailable"):
                      order.workerComments!.value,
                      style: getTextStyleAbel(17, blueColor),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget clientNotesWidget(Order order) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: Column(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Text(
                  getText(context, "myNotes"),
                  style: getTextStyleAbel(20, greyColor),
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: getBoxDeco(10, optionConColor),
              width: MediaQuery.of(context).size.width / 1.1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextFormField(
                  enabled: !order.isFinished!.value,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: clientOrderCommentsController,
                  //initialValue: order.orderComment.text,
                  autofocus: false,
                  style: getTextStyleWhiteFjallone(15),
                  cursorColor: cursorTextFieldColor3,
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: getText(context, "myNotes"),
                      hintStyle: getTextStyleWhiteFjallone(15),
                      suffixIcon: IconButton(
                          onPressed: () {
                            clientOrderCommentsController.text = "";
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
      ),
    );
  }

  Widget updateNotesBtnWidget(Order order) {
    if (!order.isFinished!.value) {
      return Padding(
        padding: const EdgeInsets.only(left:8.0),
        child: GestureDetector(
          onTap: () async {
            setLoadingUpdate(true);
            order.orderComment = clientOrderCommentsController;
            OrderService os = OrderService();
        
            await os.updateClientOrderComments(order).then((value) {
              setLoadingUpdate(false);
              showSucess(context, getText(context, "notesUpdatedSuccess"));
            });
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: getBoxDeco(8, greyColor),
            child: Center(
              child: Text(
                getText(context, "updateNotes"),
                style: getTextStyleAbel(18, blueColor),
              ),
            ),
          ),
        ),
      );
    }

    return Container();
  }

  //---------- Useful Functions------------------------//
  void setLoadingUpdate(bool value) {
    setState(() {
      isLoadingUpdateComments.value = value;
    });
  }
}
