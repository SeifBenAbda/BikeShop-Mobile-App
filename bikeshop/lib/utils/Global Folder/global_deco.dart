import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//----------Colors-------------------//
const Color cursorTextFieldColor = Colors.white;
const Color cursorTextFieldColor2 = bgColor;
const Color cursorTextFieldColor3 = Colors.white;

const Color returnArrowBoxColor = blueColor;
const Color returnArrowIconColor = Colors.white; // Color(0xff999cac);

const Color optionConColor = Color(0xff262a2d);

const Color iconColor = Colors.white;

const Color bgColor = Color(0xFF121213);

const blueColor0 = Color(0xFF405EC3) ;
const Color blueColor = Color(0xFF17203A);
const Color blueColor1 = Color(0xFF81B4FF);
const Color redColor = Color(0xfff62e49);

const Color greenColor = Color(0xFF22B391);

const Color bgProductColor = Color(0xff262a2d);

const Color greyColor = Color(0xFFFEEEEE);

const Color greyColor2 = Color(0xFFF3F2F2);

//----- Text Styles-------------------//
TextStyle getTextStyleWhite(double myFontSize) {
  return GoogleFonts.abel(color: Colors.white, fontSize: myFontSize);
}

TextStyle getTextStyleAbel(double myFontSize, Color color) {
  return GoogleFonts.fjallaOne(
      color: color, fontSize: myFontSize);
}

TextStyle getTextStyleWhiteFjallone(double myFontSize) {
  return GoogleFonts.fjallaOne(color: Colors.white, fontSize: myFontSize);
}

TextStyle getTextStyleFjallone(double myFontSize, Color color) {
  return GoogleFonts.fjallaOne(
      color: color, fontSize: myFontSize, fontWeight: FontWeight.bold);
}

TextStyle getTextStyleFjalloneBold(double myFontSize, Color color) {
  return GoogleFonts.fjallaOne(
      color: color, fontSize: myFontSize, fontWeight: FontWeight.bold);
}

//------------- Box Decorations-------------------//

BoxDecoration getBoxDeco(double radius, Color color) {
  return BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(radius),
      color: color);
}

BoxDecoration getBoxDecoWithBorder(double radius, Color color,Color borderColor) {
  return BoxDecoration(
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(radius),
      color: color);
}


BoxDecoration getSepeatorDeco(double radius, Color color) {
  return BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radius) ,bottomRight: Radius.circular(radius)),
      color: color);
}

BoxDecoration getBoxDecoShadowed(double radius, Color color) {
  return BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(radius),
      color: color.withOpacity(0.8),
      boxShadow: [
        BoxShadow(color:color.withOpacity(0.3),offset: const Offset(0, 20),blurRadius: 20)
      ]);
}

BoxDecoration getBoxDecoRightSided(double radius, Color color) {
  return BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius),
          bottomRight: Radius.circular(radius)),
      color: color);
}

BoxDecoration getBoxDecoDownOnly(double radius, Color color) {
  return BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(radius),
          bottomLeft: Radius.circular(radius)),
      color: color);
}

BoxDecoration getBoxDecoDownTop(double radius, Color color) {
  return BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(radius), topLeft: Radius.circular(radius)),
      color: color);
}
