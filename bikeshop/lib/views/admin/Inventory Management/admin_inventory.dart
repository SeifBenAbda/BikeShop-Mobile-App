import 'package:bikeshop/models/item_class.dart';
import 'package:bikeshop/services/providers/items_provider.dart';
import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/views/admin/Inventory%20Management/admin_lager_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';

class ActiveItem {
  String? activeItemId;
  ValueNotifier? isModificationMode;

  ActiveItem({required this.activeItemId, required this.isModificationMode});
}

class AdminInventory extends StatefulWidget {
  final VoidCallback toggleDrawer;
  const AdminInventory({super.key, required this.toggleDrawer});

  @override
  State<AdminInventory> createState() => _AdminInventoryState();
}

class _AdminInventoryState extends State<AdminInventory> {
  bool isReady = false;
  List<Item> itemsList = [];
  ActiveItem currentActiveItem =
      ActiveItem(activeItemId: "", isModificationMode: ValueNotifier(false));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          inventoryTopContainer(),
          const SizedBox(
            height: 30,
          ),
          adminInventoryMainWidget()
        ],
      ),
    );
  }

  Widget adminInventoryMainWidget() {
    final itemsProvider = Provider.of<ItemsProvider>(context, listen: true);
    itemsProvider.getItemsFromProvider().then((value) {
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
      return Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Text(
              getText(context, "listOfParts"),
              style: getTextStyleAbel(22, greyColor),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          itemsConsumerWidget()
        ],
      );
    }
  }

  Widget itemsConsumerWidget() {
    return Consumer<ItemsProvider>(builder: (context, itemsProvider, _) {
      itemsList = itemsProvider.listItems;
      if (itemsList.isEmpty) {
        return Container();
      }
      return Column(
        children: [
          for (int i = 0; i < itemsList.length; i++)
            Column(
              children: [
                itemWidget(itemsList[i]),
                const SizedBox(
                  height: 10,
                )
              ],
            )
        ],
      );
    });
  }

  Widget itemWidget(Item item) {
    return Container(
      decoration: getBoxDeco(12, blueColor),
      padding: const EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: [
          itemImageAndNameUpdateIcon(item),
          const SizedBox(
            height: 10,
          ),
          itemPriceAndQuantity(item),
          const SizedBox(
            height: 10,
          ),
          //updateItemBtn(item)
        ],
      ),
    );
  }

  Widget itemImageAndNameUpdateIcon(Item item) {
    String itemName =
        currentFallBackFile.value == "de" ? item.nameGerman : item.name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            itemImage(item),
            const SizedBox(
              width: 10,
            ),
            Text(
              itemName,
              style: getTextStyleAbel(19, greyColor),
            )
          ],
        ),
        itemStockWidget(item)
      ],
    );
  }

  Widget itemStockWidget(Item item) {
    return ValueListenableBuilder(
        valueListenable: item.stock,
        builder: (context, value, _) {
          if (int.parse(item.stock.value.toString()) == 0) {
            return Image.asset(
              "assets/images/out_stock.png",
              height: 40,
              width: 40,
            );
          }
          return Row(
            children: [
              Image.asset(
                "assets/images/ready_stock.png",
                height: 40,
                width: 40,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                item.stock.value.toString(),
                style: getTextStyleAbel(20, greyColor),
              )
            ],
          );
        });
  }

  Widget itemImage(Item item) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: getBoxDeco(8, greyColor),
      height: 60,
      width: 60,
      child: Center(
        child: Image.asset(
          "assets/images/${item.image}",
          height: 45,
          width: 45,
        ),
      ),
    );
  }

  Widget inventoryTopContainer() {
    return Center(
      child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              drawerBtnWidget(),
              const Spacer(),
              Text(
                getText(context, "warehouse").toUpperCase(),
                style: getTextStyleAbel(25, greyColor),
              ),
              const Spacer(),
            ],
          )),
    );
  }

  //Item Price and Quantity
  Widget x() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [itemPriceWidget()],
    );
  }

  Widget itemPriceWidget(Item item) {
    return ValueListenableBuilder(
        valueListenable: currentActiveItem.isModificationMode!,
        builder: (context, value, _) {
          return LagerInputWidget(
              label: "",
              fieldValue: "",
              isEnabled: isEnabled,
              controller: controller,
              fieldWidth: fieldWidth);
        });
  }

  Widget drawerBtnWidget() {
    return GestureDetector(
      onTap: () {
        widget.toggleDrawer;
      },
      child: Container(
        decoration: getBoxDeco(12, greyColor),
        height: 50,
        width: 50,
        child: const Center(
          child: Icon(
            Icons.menu_outlined,
            color: blueColor,
          ),
        ),
      ),
    );
  }
}
