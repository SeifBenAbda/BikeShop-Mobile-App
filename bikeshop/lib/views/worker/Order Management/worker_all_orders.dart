import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/widgets/goBack_Btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../../models/order_class.dart';
import '../../../services/providers/order_providers.dart';
import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';
import '../../../widgets/search_box.dart';

class WorkerAllOrdersPage extends StatefulWidget {
  const WorkerAllOrdersPage({super.key});

  @override
  State<WorkerAllOrdersPage> createState() => _WorkerAllOrdersPageState();
}

class _WorkerAllOrdersPageState extends State<WorkerAllOrdersPage> {
  TextEditingController searchController = TextEditingController();
  bool isReady = false;
  List<Order> allOrdersWorker = [];
  double orderContainerHeight = 140;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          workerAllPageTopContainer(),
          const SizedBox(
            height: 20,
          ),
          SearchBox(
            hintText: '',
            controller: searchController,
            onChanged: (String value) {},
            boxWidth: MediaQuery.of(context).size.width / 1.1,
          ),
          const SizedBox(
            height: 10,
          ),
          allOrderMainWidget()
        ],
      ),
    );
  }

  Widget allOrderMainWidget() {
    final allOrdersProvider =
        Provider.of<WorkerAllOrdersProvider>(context, listen: true);
    allOrdersProvider.getWorkerAllOrdersWithServices().then((value) {
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
      return openOrderListWidget();
    }
  }

  Widget openOrderListWidget() {
    return Consumer<WorkerAllOrdersProvider>(builder: (context, allOrderProvider, _) {
      allOrdersWorker = allOrderProvider.orderList;
      if (allOrdersWorker.isEmpty) {
        // Show a loading indicator or empty state if no clients are available
        return Container();
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: allOrdersWorker.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    orderServiceWidget(allOrdersWorker.elementAt(index)),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
        ),
      );
    });
  }

  Widget orderServiceWidget(Order order) {
    return Container(
      height: orderContainerHeight,
      decoration: getBoxDeco(12, blueColor),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [firstPartOrderWidget(order), startOrderButton(order)],
      ),
    );
  }

  Widget firstPartOrderWidget(Order order) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        orderId(order),
        const SizedBox(
          height: 10,
        ),

      ],
    );
  }

  Widget orderId(Order order) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.4,
      child: Row(
        children: [
          const SizedBox(width: 10,),
          Image.asset("assets/images/order.png",height: 35,width: 35,),
          const SizedBox(width: 10,),
          SizedBox(
            width: MediaQuery.of(context).size.width/1.8,
            child: AutoSizeText(
              order.orderId, 
              style: getTextStyleAbel(14, greyColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget startOrderButton(Order order) {
    return Container(
      height: orderContainerHeight,
      width: 50,
      decoration: getBoxDeco(12, greyColor),
      child: const Center(
        child: Icon(
          Icons.add_outlined,
          color: blueColor,
        ),
      ),
    );
  }

  Widget workerAllPageTopContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        children: [
          GoBackButton(callBack: goBackWorkerOrderPage),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                getText(context, "orderDashboard").toUpperCase(),
                style: getTextStyleAbel(22, greyColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //-------------------Function that uses the State --------------------------------
  void goBackWorkerOrderPage() {}
}
