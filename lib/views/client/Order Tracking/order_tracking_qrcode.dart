import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../../models/order_class.dart';
import '../../../services/order_service.dart';

class OrderTrackingQrCode extends StatefulWidget {
  final Order order;
  const OrderTrackingQrCode({super.key, required this.order});

  @override
  State<OrderTrackingQrCode> createState() => _OrderTrackingQrCodeState();
}

class _OrderTrackingQrCodeState extends State<OrderTrackingQrCode> {
  MobileScannerController cameraController = MobileScannerController();
  var isQrCodeScanPressed = ValueNotifier(false);

  var isCloseOrderAction = false;
  var isOpenOrderAction = false;
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isQrCodeScanPressed,
        builder: (context, value, _) {
          if (isQrCodeScanPressed.value) {
            return qrCodeScanner();
          }
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: getBoxDeco(12, greyColor),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                orderQrCodeWidget(),
                const SizedBox(
                  height: 20,
                ),
                qrCodeFinishOrderScannerBtn(),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Center(
                      child: AutoSizeText(
                    getText(
                        context,
                        widget.order.isFinished!.value
                            ? "reopenOrderInfo"
                            : "closeOrderInfo"),
                    style: getTextStyleAbel(12, blueColor),
                    textAlign: TextAlign.center,
                  )),
                )
              ],
            ),
          );
        });
  }

  //Widget shows Current Order Qr Code to be Scanned from Worker in Order to quick Access the Order quickly
  Widget orderQrCodeWidget() {
    return SizedBox(
      height: 300,
      width: 300,
      child: PrettyQrView.data(
        data: widget.order.orderId,
        decoration: const PrettyQrDecoration(
          shape: PrettyQrSmoothSymbol(
            color: blueColor,
          ),
        ),
      ),
    );
  }

  //This Button Opens the User Camera to Scan Qr Code on Worker Screen to give access to fiish it
  Widget qrCodeFinishOrderScannerBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isQrCodeScanPressed.value = true;
        });
      },
      child: Container(
        decoration: getBoxDeco(12, blueColor),
        height: 50,
        width: MediaQuery.of(context).size.width / 1.1,
        child: Center(
          child: Text(
            getText(
                context,
                widget.order.isFinished!.value
                    ? "reopenOrderNow"
                    : "closeOrder"),
            style: getTextStyleAbel(18, greyColor),
          ),
        ),
      ),
    );
  }

  Widget qrCodeScanner() {
    return AiBarcodeScanner(
      overlayColor: bgColor,
      borderColor: Colors.white,
      bottomBarText: getText(context, "scanQRCode"),
      controller: cameraController,
      onScan: (String value)  {
        
      },
      onDispose: () async {
        print("disposed");

      },
      onDetect: (BarcodeCapture barcodeCapture)  {
        //print(barcodeCapture);
        /*if (isCloseOrderAction) {
          closeOrderFn(widget.order);
        } else if (isOpenOrderAction) {
          openOrderFn(widget.order);
        } else {
          print("--------- SOME ERROR--------------------");
        }
        */
      },
      validator: (String value) {
        if (closeOrderCodeValid(value)) {
          print("closeeeeeeeeeeeeeeee now");
          closeOrderFn(widget.order);
          return true;
        } else if (reopenOrderCodeValid(value)) {
          openOrderFn(widget.order);
          return true;
        }
        return false;
      },
    );
  }

  //---close order qr code valid
  bool closeOrderCodeValid(String value) {
    return value.startsWith('order_') &&
        value.contains(widget.order.orderId.toString()) &&
        value.endsWith('_finish');
  }

  //--reopen qr code valid
  bool reopenOrderCodeValid(String value) {
    return value.startsWith('order_') &&
        value.contains(widget.order.orderId.toString()) &&
        value.endsWith('_reopen');
  }

  //--Close Order
  void closeOrderFn(Order order) async {
    OrderService os = OrderService();
    await setupEndTimeOfOrder(order).then(((value) async {
      await os.updateOrderToServer(order).then((value) {
        showSucess(context, getText(context, "orderClosed"));
      });
    }));
  }

  void openOrderFn(Order order) async {
    OrderService os = OrderService();
    await setupReOpenTimeOfOrder(order).then(((value) async {
      await os.updateOrderToServer(order).then((value) {
        showSucess(context, getText(context, "orderReopened"));
      });
    }));
  }

  Future<void> setupEndTimeOfOrder(Order order) async {
    DateTime? currentStartedTime = order.startedAt;

    order.isFinished!.value = true;
    order.finishedAt = DateTime.now();
    order.startedAt = currentStartedTime;
  }

  Future<void> setupReOpenTimeOfOrder(Order order) async {
    order.isFinished!.value = false;
    order.isStarted!.value = true;
    order.finishedAt = null;
    order.startedAt = DateTime.now();
  }
}
