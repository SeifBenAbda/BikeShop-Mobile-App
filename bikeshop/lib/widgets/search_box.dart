import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String value) onChanged;
  final double boxWidth;
  const SearchBox(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.onChanged,
      required this.boxWidth});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxWidth,
      child: Column(
        children: [if (widget.hintText != "") 
        Column(
          children: [
            hintTextWidget(),const SizedBox(height: 5,)
          ],
        ),
        searchContainer()],
      ),
    );
  }

  Widget hintTextWidget() {
    return Container();
  }

  Widget searchContainer(){
    return Container(
      height: 50,
      width: widget.boxWidth,
      decoration: getBoxDeco(12, greyColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(
              Icons.search_outlined,
              size: 20,
              color: blueColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: searchTextField(),
          ),
        ],
      ),
    );
  }


  Widget searchTextField() {
    return Container(
      color: Colors.transparent,
      height: 50,
      width: widget.boxWidth -110,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: TextFormField(
            controller: widget.controller,
            autofocus: false,
            style: getTextStyleAbel(15, blueColor),
            cursorColor: cursorTextFieldColor3,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: getText(context, "searchOrder"),
              hintStyle: getTextStyleAbel(15, blueColor),
            ),
            onChanged: (val) {
              widget.onChanged(val);
            },
          ),
        ),
      ),
    );
  }

}
