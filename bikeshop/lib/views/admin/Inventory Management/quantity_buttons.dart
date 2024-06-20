import 'package:bikeshop/models/lager_items_class.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';

class StockButtonWidget extends StatefulWidget {
  final LagerItem item;
  const StockButtonWidget({super.key, required this.item});

  @override
  State<StockButtonWidget> createState() => _StockButtonsWidgetState();
}

class _StockButtonsWidgetState extends State<StockButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: MediaQuery.of(context).size.width / 2.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(getText(context, "stock"),style: getTextStyleAbel(17, greyColor),),
          const SizedBox(height: 5,),
          Row(
            children: [
              stockButton(-1),
              const SizedBox(
                width: 20,
              ),
              stockButton(1),
            ],
          ),
        ],
      ),
    );
  }

  Widget stockButton(int value) {
    return GestureDetector(
      onTap: (){
        //update tock
      },
      child: Container(
        height: 45,
        decoration: getBoxDeco(8, value==-1?redColor:greenColor),
        width: MediaQuery.of(context).size.width/7,
        child: Center(
          child: Text(value==-1?"-":"+",style: getTextStyleAbel(19, greyColor),),
        ),
      ),
    );
  }
}
