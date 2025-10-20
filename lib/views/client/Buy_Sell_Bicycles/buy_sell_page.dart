import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';

class BuyAndSellPage extends StatefulWidget {
  const BuyAndSellPage({super.key});

  @override
  State<BuyAndSellPage> createState() => _BuyAndSellPageState();
}

class _BuyAndSellPageState extends State<BuyAndSellPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(getText(context, "buySellDesc"),style: getTextStyleWhiteFjallone(25),),
      ),
    );
  }
}