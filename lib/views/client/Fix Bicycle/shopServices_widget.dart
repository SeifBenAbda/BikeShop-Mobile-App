import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_func.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_vars.dart';
import 'package:flutter/material.dart';

import '../../../models/shop_service_class.dart';

class ShopServicesWidget extends StatefulWidget {
  final List<ShopService> listOfShopServices;
  const ShopServicesWidget({super.key, required this.listOfShopServices});

  @override
  State<ShopServicesWidget> createState() => _ShopServicesWidgetState();
}

class _ShopServicesWidgetState extends State<ShopServicesWidget> {
  var servicePerRow = 1;
  @override
  Widget build(BuildContext context) {
    servicePerRow =
        MediaQuery.of(context).size.width ~/ 170; // Adjust the width as needed
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10, // spacing between services
          runSpacing: 10, // spacing between lines of services
          children: List.generate(widget.listOfShopServices.length, (index) {
            if (widget.listOfShopServices
                .elementAt(index)
                .isServiceAvailable
                .value) {
              return shopService(index);
            }
            return Container(
              width: servicePerRow == 1
                  ? MediaQuery.of(context).size.width / 1.2
                  : 175,
            );
          }),
        ),
      ),
    );
  }

  Widget shopService(int serviceIndex) {
    return SizedBox(
      width: servicePerRow == 1 ? MediaQuery.of(context).size.width / 1.2 : 175,
      height: MediaQuery.of(context).size.height / 4,
      child: Stack(
        children: [
          Container(
            decoration: getBoxDeco(12, blueColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  serviceNameAndImage(serviceIndex),
                  const Spacer(),
                  serviceDetails(serviceIndex),
                  const Spacer()
                ],
              ),
            ),
          ),
          Positioned(top: 0, right: 0, child: discountWidget(serviceIndex)),
          Positioned(
              top: 0, left: 0, child: addServiceBasketButton(serviceIndex)),
        ],
      ),
    );
  }

  Widget serviceNameAndImage(int serviceIndex) {
    String serviceName = currentFallBackFile.value == "en"
        ? widget.listOfShopServices.elementAt(serviceIndex).serviceName
        : widget.listOfShopServices.elementAt(serviceIndex).serviceNameGerman;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/images/${widget.listOfShopServices.elementAt(serviceIndex).serviceImage}",
          height: 40,
          width: 40,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: servicePerRow == 1
              ? MediaQuery.of(context).size.width / 1.2
              : 175,
          child: Center(
            child: AutoSizeText(
              serviceName,
              style: getTextStyleAbel(14, greyColor),
              maxFontSize: 14,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget discountWidget(int serviceIndex) {
    double serviceDiscount =
        widget.listOfShopServices.elementAt(serviceIndex).serviceDiscount.value;
    return serviceDiscount != 0.0
        ? SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Text(
                    "$serviceDiscount",
                    style: getTextStyleAbel(15, greyColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    "assets/images/discount.png",
                    height: 20,
                    width: 20,
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget addServiceBasketButton(int serviceIndex) {
    return GestureDetector(
      onTap: () {
        addDeleteFunction(serviceIndex);
      },
      child: Container(
        decoration: getBoxDeco(12, greyColor),
        height: 40,
        width: 40,
        child: Center(child: addDeleteIcon(serviceIndex)),
      ),
    );
  }

  Widget addDeleteIcon(int serviceIndex) {
    ShopService service = widget.listOfShopServices.elementAt(serviceIndex);
    return ValueListenableBuilder(
        valueListenable: service.isInBasket,
        builder: (context, value, _) {
          return Icon(
            !service.isInBasket.value
                ? Icons.add_outlined
                : Icons.delete_outlined,
            color: bgColor,
            size: 20,
          );
        });
  }

  //-----------Service Details------------------//
  Widget serviceDetails(int serviceIndex) {
    return Column(
      children: [
        serviceDuration(serviceIndex),
        const SizedBox(
          height: 10,
        ),
        servicePrice(serviceIndex)
      ],
    );
  }

  Widget serviceDuration(int serviceIndex) {
    String serviceDuration =
        "${widget.listOfShopServices.elementAt(serviceIndex).serviceDuration.inMinutes} Min";
    return Container(
      decoration: getBoxDeco(5, greyColor),
      width: servicePerRow == 1 ? MediaQuery.of(context).size.width / 1.2 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/duration.png",
            height: 25,
            width: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
              child: Text(
            serviceDuration,
            style: getTextStyleAbel(15, bgColor),
          ))
        ],
      ),
    );
  }

  Widget servicePrice(int serviceIndex) {
    String servicePrice =
        "${widget.listOfShopServices.elementAt(serviceIndex).servicePrice} €";
    return Container(
      decoration: getBoxDeco(5, greyColor),
      width: servicePerRow == 1 ? MediaQuery.of(context).size.width / 1.2 : 175,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/price.png",
            height: 25,
            width: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
              child: Text(
            servicePrice,
            style: getTextStyleAbel(15, bgColor),
          ))
        ],
      ),
    );
  }

  void addDeleteFunction(int serviceIndex) async {
    ShopService s = widget.listOfShopServices.elementAt(serviceIndex);
    String serviceName =
        currentFallBackFile.value == "en" ? s.serviceName : s.serviceNameGerman;
    if (!isServiceInBasket(s)) {
      setState(() {
        s.isInBasket.value = true;
        numberOfItemsBasket.value++;
      });
      addServiceToOrder(widget.listOfShopServices.elementAt(serviceIndex));

      showSucess(context,
          "${getText(context, serviceName)} ${getText(context, "addedToBasket")}");
    } else {
      //TODO: Implement deleting Service from Basket
      print("Deleting Service Here");
      setState(() {
        s.isInBasket.value = false;
        numberOfItemsBasket.value--;
      });
      deleteServiceInOrder(s);
    }
  }

  void addServiceToOrder(ShopService service) {
    currentOrder!.orderedServices.value.add(service);
    double servicePrice = service.servicePrice -
        ((service.servicePrice * service.serviceDiscount.value) / 100);
    setState(() {
      totalAmountOrder.value += servicePrice;
      currentOrder!.totalAmount.value = totalAmountOrder.value;
    });
  }

  void deleteServiceInOrder(ShopService service) {
    int index = currentOrder!.orderedServices.value
        .indexWhere((myService) => myService.serviceId == service.serviceId);
    
    double servicePrice = service.servicePrice -
        ((service.servicePrice * service.serviceDiscount.value) / 100);
    setState(() {
      currentOrder!.orderedServices.value.removeAt(index);
      totalAmountOrder.value -= servicePrice;
      currentOrder!.totalAmount.value = totalAmountOrder.value;
    });
  }
}
