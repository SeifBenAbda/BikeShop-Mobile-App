import 'package:flutter/material.dart';

import '../../../utils/Global Folder/global_deco.dart';

class LagerInputWidget extends StatefulWidget {
  final String label;
  final String fieldValue;
  final bool isEnabled;
  final TextEditingController? controller ;
  final double fieldWidth;
  const LagerInputWidget(
      {super.key,
      required this.label,
      required this.fieldValue,
      required this.isEnabled,
      required this.controller,
      required this.fieldWidth});

  @override
  State<LagerInputWidget> createState() => _LagerInputWidgetState();
}

class _LagerInputWidgetState extends State<LagerInputWidget> {
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
              maxLines: 1,
              keyboardType: TextInputType.text,
              controller: widget.controller,
              initialValue: widget.fieldValue,
              autofocus: false,
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
