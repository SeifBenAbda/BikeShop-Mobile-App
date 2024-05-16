import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_deco.dart';
import '../../../utils/Global Folder/global_func.dart';

class OrderTrackingClient extends StatefulWidget {
  const OrderTrackingClient({super.key});

  @override
  State<OrderTrackingClient> createState() => _OrderTrackingClientState();
}

class _OrderTrackingClientState extends State<OrderTrackingClient> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(getText(context, "orderTrack"),style: getTextStyleWhiteFjallone(25),),
      ),
    );
  }
}