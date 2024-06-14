import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_deco.dart';

class WorkerProfileField extends StatefulWidget {
  final String label;
  final String fieldValue;
  final bool isEnabled;
  final bool isObscured;
  final TextEditingController? controller;
  final double fieldWidth;
  const WorkerProfileField(
      {super.key,
      required this.label,
      required this.fieldValue,
      required this.isEnabled,
      required this.isObscured,
      required this.controller,
      required this.fieldWidth});

  @override
  State<WorkerProfileField> createState() => _WorkerProfileFieldState();
}

class _WorkerProfileFieldState extends State<WorkerProfileField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        inputHint(),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: getBoxDeco(10, blueColor),
          //height: payementTextFieldHeight,
          width: widget.fieldWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              enabled: widget.isEnabled,
              minLines: 1,
              maxLines: widget.isObscured ? 1 : null,
              keyboardType: TextInputType.text,
              controller: widget.controller,
              initialValue: widget.fieldValue,
              autofocus: false,
              obscureText: widget.isObscured,
              style: getTextStyleWhiteFjallone(15),
              cursorColor: cursorTextFieldColor3,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                hintStyle: getTextStyleWhiteFjallone(15),
              ),
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
        widget.label,
        style: getTextStyleWhiteFjallone(15),
      ),
    );
  }
}
