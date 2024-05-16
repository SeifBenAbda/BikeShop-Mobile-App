import 'package:flutter/material.dart';

import '../utils/Global Folder/global_deco.dart';

class GoBackButton extends StatefulWidget {
  final Function() callBack;
  const GoBackButton({super.key, required this.callBack});

  @override
  State<GoBackButton> createState() => _GoBackButtonState();
}

class _GoBackButtonState extends State<GoBackButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        widget.callBack();
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: getBoxDeco(15, greyColor),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: bgColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
