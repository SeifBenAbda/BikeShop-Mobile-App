import 'package:bikeshop/services/items_service.dart';
import 'package:bikeshop/services/providers/items_provider.dart';
import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item_class.dart';
import '../../../models/order_class.dart';

List<Item> listOfItems = [];
List<RequestedItems> listOfRqItems = [];

class WorkerOrderPartsChange extends StatefulWidget {
  final Order order;
  const WorkerOrderPartsChange({super.key, required this.order});

  @override
  State<WorkerOrderPartsChange> createState() => _WorkerOrderPartsChangeState();
}

class _WorkerOrderPartsChangeState extends State<WorkerOrderPartsChange> {
  var isLoading = ValueNotifier(false);
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getBoxDeco(12, greyColor),
      child: Stack(
        children: [mainItemsWidget(), loadingWidget(isLoading)],
      ),
    );
  }

  //------------------ Loading Widget---------------------------------//
  Widget loadingWidget(ValueNotifier valueNotifier) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, isLoading, _) {
        return isLoading
            ? Container(
                //color: greyColor.withOpacity(0.3),
                decoration: getBoxDeco(12, greyColor.withOpacity(0.2)),
                child: const Center(
                  child: CircularProgressIndicator(color: blueColor),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  //--------------- Main Items Widget---------------------------------------//

  Widget mainItemsWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: Text(
              getText(context, "changeParts"),
              style: getTextStyleAbel(22, blueColor),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: itemsListWidget())
        ],
      ),
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
            child: CircularProgressIndicator(color: blueColor),
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
        width: MediaQuery.of(context).size.width / 1.1,
        //height: MediaQuery.of(context).size.height / 4,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < listOfItems.length; i++)
                Column(
                  children: [
                    itemWidget(listOfItems.elementAt(i)),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }

  Widget itemWidget(Item item) {
    return Container(
      height: isItemRequested(item) && !isItemAccepted(item) && !itemIsRejected(item) ? 110 : 80,
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: getBoxDeco(12, blueColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [itemDetails(item), itemChangeBtns(item)],
        ),
      ),
    );
  }

  Widget itemChangeBtns(Item item) {
    if (isItemRequested(item) && !isItemAccepted(item) && !itemIsRejected(item)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [requestItemChangeBtn(item), cancelItemRequestBtn(item)],
      );
    }
    return requestItemChangeBtn(item);
  }

  Widget itemDetails(Item item) {
    bool isGerman = currentFallBackFile.value == "de";
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        mainAxisAlignment: isItemRequested(item) && !isItemAccepted(item) && !itemIsRejected(item)
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
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
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                "${getText(context, "stock")} : ${item.stock.value}",
                style: getTextStyleAbel(15, greyColor),
              )),
          isItemRequested(item) && !isItemAccepted(item) && !itemIsRejected(item)
              ? const SizedBox(
                  height: 5,
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget requestItemChangeBtn(Item item) {
    return GestureDetector(
      onTap: () {
        itemRequestFn(item);
      },
      child: Container(
        decoration: getRequestDeco(item),
        height: 40,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: Text(
            getRequestStatusText(item),
            style: isItemRequested(item)
                ? getTextStyleAbel(14, greyColor)
                : getTextStyleAbel(14, blueColor),
          ),
        ),
      ),
    );
  }

  Widget cancelItemRequestBtn(item) {
    return GestureDetector(
      onTap: () {
        itemRequestFn(item);
      },
      child: Container(
        decoration: getBoxDeco(8, greyColor2),
        height: 40,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Center(
          child: Text(
            getText(context, "cancelRequest"),
            style: getTextStyleAbel(14, blueColor),
          ),
        ),
      ),
    );
  }

  //--------------Useful Functions-------------------------------------//

  bool isItemRequested(Item item) {
    int index =
        listOfRqItems.indexWhere((element) => element.itemId == item.id);

    return index != -1;
  }

  bool itemIsRejected(Item item) {
    int index =
        listOfRqItems.indexWhere((element) => element.itemId == item.id);
    return listOfRqItems.elementAt(index).requestTime == null;
  }

  bool isItemAccepted(Item item) {
    int index =
        listOfRqItems.indexWhere((element) => element.itemId == item.id);
    return listOfRqItems.elementAt(index).isAccepted.value == true &&
        listOfRqItems.elementAt(index).requestTime != null;
  }

  void itemRequestFn(Item item) async {
    //this works when item is not requested yet
    //is Item not reuqetsed ? -> send request to server
    //is Item rejected ? -> send requestto server
    ItemsService iss = ItemsService();
    if (!isItemRequested(item)) {
      await iss.requestItemChangeWorker(widget.order, item).then((value) {
        print("Item Requested ");
      });
    } else if (itemIsRejected(item)) {
      int index =
          listOfRqItems.indexWhere((rqItem) => rqItem.itemId == item.id);
      RequestedItems rqItem = listOfRqItems.elementAt(index);
      await iss.requestItemAfterDecline(widget.order, rqItem).then((value) {
        print("Item Requested ");
      });
    }
  }

  String getRequestStatusText(Item item) {
    if (isItemRequested(item)) {
      if (itemIsRejected(item)) {
        return getText(context, "requestRejected");
      } else if (isItemAccepted(item)) {
        return getText(context, "requestAccepted");
      } else {
        return getText(context, "requestPending");
      }
    }

    return getText(context, "request");
  }

  BoxDecoration getRequestDeco(Item item) {
    if (isItemRequested(item)) {
      if (itemIsRejected(item)) {
        return getBoxDeco(8, redColor);
      } else if (isItemAccepted(item)) {
        return getBoxDeco(8, greenColor);
      } else {
        return getBoxDeco(8, blueColor1);
      }
    }

    return getBoxDeco(8, greyColor2);
  }
}
