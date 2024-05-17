import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/models/shop_service_class.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_vars.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../utils/Global Folder/glaobal_vars.dart';
import 'basket_checkout_page.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: numberOfItemsBasket,
        builder: (context, value, _) {
          if (numberOfItemsBasket.value == 0) {
            return emptyBasketWidget();
          }
          return mainBasketWidget();
        });
  }

  Widget emptyBasketWidget() {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/emptyCart.png",
          height: 120,
          width: 120,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Center(
            child: Text(
              getText(context, "basketIsEmpty"),
              style: getTextStyleFjallone(20, greyColor),
            ),
          ),
        )
      ],
    ));
  }

  Widget mainBasketWidget() {
    return Expanded(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(child: listOfOrderServices()),
        Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            width: 10,
          ),
          seperator(),
          const SizedBox(height: 20),
          const BasketCheckout()
        ])
      ]),
    );
  }

  Widget listOfOrderServices() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: currentOrder!.orderedServices.value.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  orderServiceWidget(
                      currentOrder!.orderedServices.value.elementAt(index)),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget seperator() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width / 1.1,
      color: greyColor,
    );
  }

  Widget orderServiceWidget(ShopService orderService) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: getBoxDeco(12, blueColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            serviceNameAndImage(orderService),
            const SizedBox(
              height: 10,
            ),
            servicePrice(orderService)
          ],
        ),
      ),
    );
  }

  Widget serviceNameAndImage(ShopService orderService) {
    String serviceName = currentFallBackFile.value == "en"
        ? orderService.serviceName
        : orderService.serviceNameGerman;
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.2,
            child: AutoSizeText(
              serviceName,
              style: getTextStyleAbel(18, greyColor),
            ),
          ),
          Image.asset(
            "assets/images/${orderService.serviceImage}",
            height: 50,
            width: 50,
          )
        ],
      ),
    );
  }

  Widget servicePrice(ShopService orderService) {
    String servicePrice = "${orderService.servicePrice} €";
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          deleteServiceFromBasketWidget(orderService),
          Row(
            children: [
              Image.asset(
                "assets/images/price.png",
                height: 30,
                width: 30,
              ),
              const SizedBox(width: 10),
              Text(servicePrice, style: getTextStyleAbel(18, greyColor)),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }

  Widget deleteServiceFromBasketWidget(ShopService orderService) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        deleteServiceInOrder(orderService);
      },
      child: Container(
        decoration: getBoxDeco(15, greyColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              getText(context, "remove"),
              style: getTextStyleAbel(15, bgColor),
            ),
          ),
        ),
      ),
    );
  }

  //---function that manipulate the state
  void deleteServiceInOrder(ShopService service) {
    int index = currentOrder!.orderedServices.value
        .indexWhere((myService) => myService.serviceId == service.serviceId);

    double servicePrice = service.servicePrice -
        ((service.servicePrice * service.serviceDiscount.value) / 100);
    setState(() {
      currentOrder!.orderedServices.value.removeAt(index);
      totalAmountOrder.value -= servicePrice;
      currentOrder!.totalAmount.value = totalAmountOrder.value;
      numberOfItemsBasket.value--;
      service.isInBasket.value = false;
    });
  }
}
