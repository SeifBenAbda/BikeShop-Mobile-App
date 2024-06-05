import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_func.dart';

TextEditingController clientOrderCommentsController = TextEditingController();

List<Widget> getTabsWidget(BuildContext context) {
  return [
    Tab(
      icon: Image.asset(
        "assets/images/service.png",
        height: 30,
        width: 30,
      ),
      text: getText(context, "services"),
    ),
    Tab(
      icon: Image.asset(
        "assets/images/notes.png",
        height: 30,
        width: 30,
      ),
      text: getText(context, "notes"),
    ),
    Tab(
      icon: Image.asset(
        "assets/images/fix_wheel.png",
        height: 30,
        width: 30,
      ),
      text: getText(context, "changeParts"),
    ),
  ];
}
