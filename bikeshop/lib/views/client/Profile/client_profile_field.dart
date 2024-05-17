import 'package:flutter/material.dart';

class ClientProfileField extends StatefulWidget {
  final String fieldValue;
  final bool isObscured;
  final TextEditingController controller;
  final double fieldWidth;
  const ClientProfileField({super.key, required this.fieldValue, required this.isObscured, required this.controller, required this.fieldWidth});

  @override
  State<ClientProfileField> createState() => _ClientProfileFieldState();
}

class _ClientProfileFieldState extends State<ClientProfileField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        inputHint(context),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: getBoxDeco(10, optionConColor),
          //height: payementTextFieldHeight,
          width: fieldWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              minLines: 1,
              maxLines: isPasswordField?1:null,
              keyboardType: TextInputType.text,
              controller: controller,
              autofocus: false,
              obscureText: isPasswordField,
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




  Widget inputHint() {
    return SizedBox(
      width: widget.fieldWidth - 10,
      child: Text(
        label,
        style: getTextStyleWhiteFjallone(15),
      ),
    );
  }
}
