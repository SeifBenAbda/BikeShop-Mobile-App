import 'package:bikeshop/services/providers/shopServices_provider.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/Fix%20Bike%20Basket/basket_page.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/shopServices_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/Global Folder/global_deco.dart';
import '../../../widgets/goBack_Btn.dart';
import 'fix_bike_func.dart';
import 'fix_bike_vars.dart';

class FixBikePage extends StatefulWidget {
  const FixBikePage({super.key});

  @override
  State<FixBikePage> createState() => _FixBikePageState();
}

class _FixBikePageState extends State<FixBikePage> {
  bool isReady = false;

  @override
  void initState() {
    initiateBasket();
    numberOfItemsBasket.value = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            topContainerFixBike(),
           
            ValueListenableBuilder(
                valueListenable: isBasketBikeFixActive,
                builder: (context, value, _) {
                  if (isBasketBikeFixActive.value) {
                    return const BasketPage();
                  }
                  return Expanded(child: mainFixBikeWidget());
                })
          ],
        ));
  }

  Widget topContainerFixBike() {
    return SizedBox(
      //height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 10,
          ),
          GoBackButton(
            callBack: fixBikeReturnFunc,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                getText(context, "fixYourBicycle").toUpperCase(),
                style: getTextStyleAbel(22, greyColor),
              ),
            ),
          ),
          basketWidget(),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget basketWidget() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        setState(() {
          isBasketBikeFixActive.value = true;
        });
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: getBoxDeco(15, greyColor),
        child: const Center(
          child: Icon(
            Icons.shopping_cart_outlined,
            color: bgColor,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget mainFixBikeWidget() {
    final shopServiceProvider =
        Provider.of<ShopServiceProvider>(context, listen: true);
    shopServiceProvider.getShopServices().then((value) {
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
      return listOfServicesWidget();
    }
  }

  Widget listOfServicesWidget() {
    return Consumer<ShopServiceProvider>(
        builder: (context, shopServiceProvider, _) {
      listOfShopServices = shopServiceProvider.shopServicesList;

      if (listOfShopServices.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return ShopServicesWidget(
        listOfShopServices: listOfShopServices,
      );
    });
  }

  //---Functions that manipulate state
  void goBackFromBasket() {
    setState(() {
      isBasketBikeFixActive.value = false;
    });
  }

  void fixBikeReturnFunc() {
    if (isBasketBikeFixActive.value) {
      goBackFromBasket();
    } else {
      goHomePageClient();
    }
  }
}
