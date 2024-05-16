import 'package:auto_size_text/auto_size_text.dart';
import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';

import '../../../models/shop_service_class.dart';

class ShopServicesWidget extends StatefulWidget {
  final List<ShopService> listOfShopServices;
  const ShopServicesWidget({super.key, required this.listOfShopServices});

  @override
  State<ShopServicesWidget> createState() => _ShopServicesWidgetState();
}

class _ShopServicesWidgetState extends State<ShopServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < widget.listOfShopServices.length; i++)
          Column(
            children: [
              shopService(i),
              const SizedBox(
                height: 10,
              )
            ],
          )
      ],
    );
  }

  Widget shopService(int serviceIndex) {
   
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      decoration: getBoxDeco(12, blueColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [serviceNameAndImage(serviceIndex)],
        ),
      ),
    );
  }

  Widget serviceNameAndImage(int serviceIndex) {
     String serviceName = currentFallBackFile.value == "en"
        ? widget.listOfShopServices.elementAt(serviceIndex).serviceName
        : widget.listOfShopServices.elementAt(serviceIndex).serviceNameGerman;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width/1.9,
          child: AutoSizeText(serviceName,style: getTextStyleAbel(16, greyColor),)),
        Image.asset("assets/images/${widget.listOfShopServices.elementAt(serviceIndex).serviceImage}",height: 40,width: 40,)  
      ],
    );
  }
}
