import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';

Widget topClientHomePageWidgetWeb(BuildContext context) {
  return Column(
    children: [
      const SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 60,
        width: double.infinity,
        child: Row(
          children: [appNameAndLogoWeb(context)],
        ),
      )
    ],
  );
}

Widget appNameAndLogoWeb(BuildContext context) {
  return SizedBox(
    height: 50,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10,),
          Image.asset("assets/images/app_logo.png",height: 40,width: 40,),
          const SizedBox(width: 10,),
          Text("BIKE SHOP",style: getTextStyleWhiteFjallone(20)

      ),
        ]))
  );
}
