import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/Fix%20Bike%20Basket/basket_func.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_vars.dart';
import 'package:flutter/material.dart';

class BasketCheckout extends StatefulWidget {
  const BasketCheckout({super.key});

  @override
  State<BasketCheckout> createState() => _BasketCheckoutState();
}

class _BasketCheckoutState extends State<BasketCheckout> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: totalAmountOrder,
        builder: (context, value, _) {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: getBoxDeco(12, greyColor),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    checkoutWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    totalDurationWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                    totalAmountToPayWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              payButton(),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  Widget checkoutWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Text("CHECKOUT", style: getTextStyleFjalloneBold(20, bgColor)),
    );
  }

  //--- Total Duration
  Widget totalDurationWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getText(context, "timeToTake"),
              style: getTextStyleAbel(16, bgColor)),
          Row(
            children: [
              Image.asset(
                "assets/images/duration.png",
                height: 25,
                width: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                getTotalDurationBakset(),
                style: getTextStyleAbel(16, bgColor),
              )
            ],
          )
        ],
      ),
    );
  }

  //--- Total Price
  Widget totalAmountToPayWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getText(context, "totalPrice"),
              style: getTextStyleAbel(16, bgColor)),
          Row(
            children: [
              Image.asset(
                "assets/images/price.png",
                height: 25,
                width: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                getTotalPrice(),
                style: getTextStyleAbel(16, bgColor),
              )
            ],
          )
        ],
      ),
    );
  }

  //Pay Button

  Widget payButton() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: getBoxDeco(12, greyColor),
      child: Center(
        child: Text(
          getText(context, "proceedToPayment"),
          style: getTextStyleAbel(18, bgColor),
        ),
      ),
    );
  }
}
