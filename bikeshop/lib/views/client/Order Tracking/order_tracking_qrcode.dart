import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../../models/order_class.dart';

class OrderTrackingQrCode extends StatefulWidget {
  final Order order;
  const OrderTrackingQrCode({super.key, required this.order});

  @override
  State<OrderTrackingQrCode> createState() => _OrderTrackingQrCodeState();
}

class _OrderTrackingQrCodeState extends State<OrderTrackingQrCode> {
  MobileScannerController cameraController = MobileScannerController();
  var isQrCodeScanPressed = ValueNotifier(false);

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
                    getText(context, "closeOrderInfo"),
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
            getText(context, "closeOrder"),
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
      onScan: (String value) {
        print(value);
      },
      onDispose: () {
        print("disposed");
      },
      onDetect: (BarcodeCapture barcodeCapture) {
        //print(barcodeCapture);
      },
      validator: (String value) {
        if (value.startsWith('order_') && value.contains(widget.order.orderId.toString()) && value.endsWith('_finish')) {
          return true;
        }
        return false;
      },
    );
  }
}
