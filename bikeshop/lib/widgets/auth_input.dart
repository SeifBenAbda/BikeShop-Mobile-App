import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/material.dart';

import '../utils/typedef.dart';

class AuthInput extends StatelessWidget {
  final String hintText, label;
  final TextEditingController controller;
  final bool isPasswordField;
  final ValidatorCallback? callback;
  const AuthInput({
    required this.hintText,
    required this.label,
    required this.controller,
    this.callback,
    this.isPasswordField = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        inputHint(context),
        const SizedBox(height: 5,),
        Container(
          decoration: getBoxDeco(10, optionConColor),
          //height: payementTextFieldHeight,
          width: MediaQuery.of(context).size.width / 1.2,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.text,
              controller: controller,
              autofocus: false,
              style: getTextStyleWhiteFjallone(15),
              cursorColor: cursorTextFieldColor3,
              decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: getTextStyleWhiteFjallone(15),
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.text = "";
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 20,
                      ))),
            ),
          ),
        ),
      ],
    );
  }

  Widget inputHint(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.2 - 10,
      child: Text(label,style: getTextStyleWhiteFjallone(15),),
    );
  }
}
