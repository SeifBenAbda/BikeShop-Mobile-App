import 'package:bikeshop/services/items_service.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item_class.dart';
import '../../../models/order_class.dart';
import '../../../services/providers/items_provider.dart';
import '../../../utils/Global Folder/glaobal_vars.dart';
import '../../../utils/Global Folder/global_func.dart';

class OrderTrackingItemChange extends StatefulWidget {
  final Order order;
  const OrderTrackingItemChange({super.key, required this.order});

  @override
  State<OrderTrackingItemChange> createState() =>
      _OrderTrackingItemChangeState();
}

class _OrderTrackingItemChangeState extends State<OrderTrackingItemChange> {
  var isLoading = ValueNotifier(false);
  bool isReady = false;
  List<Item> listOfItems = [];
  List<RequestedItems> listOfRqItems = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [itemsListWidget(), loadingWidget(isLoading)],
      ),
    );
  }

  //------------------ Loading Widget---------------------------------//
  Widget loadingWidget(ValueNotifier valueNotifier) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, isLoading, _) {
        return isLoading
            ? const SizedBox(
                child: Center(
                  child: CircularProgressIndicator(color: greyColor),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget itemsListWidget() {
    if (mounted) {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: true);
      itemsProvider.getRequestsItemsForOrder(widget.order);
      itemsProvider.getItemsFromProvider().then((value) {
        isReady = true;
      }).onError((error, stackTrace) {
        isReady = true;
      });
      if (!isReady) {
        return Container(
          color: Colors.transparent,
          child: const Center(
            child: CircularProgressIndicator(color: greyColor),
          ),
        );
      } else {
        return mainItemsList();
      }
    }
    return Container();
  }

  Widget mainItemsList() {
    return Consumer<ItemsProvider>(builder: (context, itemsProvider, _) {
      listOfItems = itemsProvider.listItems;
      listOfRqItems = itemsProvider.listRequestedItems;
      if (listOfItems.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.05,
        //height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < listOfItems.length; i++)
                if (isItemRequested(listOfItems.elementAt(i)))
                  Column(
                    children: [
                      itemWidget(listOfItems.elementAt(i)),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
            ],
          ),
        ),
      );
    });
  }

  Widget itemWidget(Item item) {
    return Container(
      height: 110,
      width: MediaQuery.of(context).size.width / 1.05,
      decoration: getBoxDeco(12, blueColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [itemDetails(item), requestButtons(item)],
        ),
      ),
    );
  }

  Widget itemDetails(Item item) {
    bool isGerman = currentFallBackFile.value == "de";
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/${item.image}",
                height: 35,
                width: 35,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                isGerman ? item.nameGerman : item.name,
                style: getTextStyleAbel(16, greyColor),
              )
            ],
          ),
          const Spacer(),
          SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/price.png",
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${item.price.toStringAsFixed(2)} €",
                    style: getTextStyleAbel(17, greyColor),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget requestButtons(Item item) {
    if (isItemAccepted(item)) {
      return itemAcceptedButton(item);
    }
    return requestAndDeclineBtns(item);
  }

  Widget itemAcceptedButton(Item item) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        decoration: getBoxDeco(8, greenColor),
        height: 40,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: Text(
            getText(context, "requestAccepted"),
            style: getTextStyleAbel(14, greyColor2),
          ),
        ),
      ),
    );
  }

  Widget requestAndDeclineBtns(Item item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [acceptItemBtn(item), const Spacer(), declineItemBtn(item)],
    );
  }

  Widget acceptItemBtn(Item item) {
    int index = listOfRqItems.indexWhere((rqItem) => rqItem.itemId == item.id);
    RequestedItems rqItem = listOfRqItems.elementAt(index);
    return GestureDetector(
      onTap: () async {
        setLoading(true);
        ItemsService iss = ItemsService();
        await iss.requestItemResponse(widget.order, rqItem, true).then((value) {
          print("Item is Accepted and Payed");
          setLoading(false);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        decoration: getBoxDeco(8, greyColor2),
        height: 40,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: Text(
            getText(context, "acceptAndPay"),
            style: getTextStyleAbel(14, blueColor),
          ),
        ),
      ),
    );
  }

  Widget declineItemBtn(Item item) {
    int index = listOfRqItems.indexWhere((rqItem) => rqItem.itemId == item.id);
    RequestedItems rqItem = listOfRqItems.elementAt(index);
    return GestureDetector(
      onTap: () async {
        setLoading(true);
        ItemsService iss = ItemsService();
        await iss
            .requestItemResponse(widget.order, rqItem, false)
            .then((value) {
          print("Item is rejected");
          setLoading(false);
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        decoration: getBoxDeco(8, redColor),
        height: 40,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: Text(getText(context, "decline"),
              style: getTextStyleAbel(14, greyColor)),
        ),
      ),
    );
  }

  bool isItemRequested(Item item) {
    int index =
        listOfRqItems.indexWhere((element) => element.itemId == item.id);
    bool isRejected = true;

    if (index != -1) {
      isRejected = listOfRqItems.elementAt(index).requestTime == null;
    }
    return index != -1 && !isRejected;
  }

  bool isItemAccepted(Item item) {
    int index =
        listOfRqItems.indexWhere((element) => element.itemId == item.id);
    return listOfRqItems.elementAt(index).isAccepted.value == true &&
        listOfRqItems.elementAt(index).requestTime != null;
  }

  void setLoading(bool value) {
    setState(() {
      isLoading.value = value;
    });
  }
}
