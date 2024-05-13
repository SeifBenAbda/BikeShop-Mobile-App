import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//----------Colors-------------------//
const Color cursorTextFieldColor = Colors.white;
const Color cursorTextFieldColor2 = bgColor;
const Color cursorTextFieldColor3 = Colors.white;

const Color returnArrowBoxColor = blueColor;
const Color returnArrowIconColor = Colors.white; // Color(0xff999cac);

const Color optionConColor =Color(0xff262a2d); 

const Color iconColor = Colors.white;

const Color bgColor = Color(0xFF121213);

const Color blueColor = Color(0xFF405EC3);

const Color redColor = Color(0xfff62e49);

const Color greenColor = Color(0xFF22B391);


const Color bgProductColor = Color(0xff262a2d); 







//----- Text Styles-------------------//
TextStyle getTextStyleWhite(double myFontSize){
  return GoogleFonts.abel(color: Colors.white, fontSize: myFontSize);
}


TextStyle getTextStyleWhiteFjallone(double myFontSize){
  return GoogleFonts.fjallaOne(color: Colors.white, fontSize: myFontSize);
}


TextStyle getTextStyleFjallone(double myFontSize,Color color){
  return GoogleFonts.fjallaOne(color: color, fontSize: myFontSize);
}



//------------- Box Decorations-------------------//

BoxDecoration getBoxDeco(double radius,Color color){
  return BoxDecoration(
    border: Border.all(color: color),
    borderRadius: BorderRadius.circular(radius),
   color: color);
}

BoxDecoration getBoxDecoRightSided(double radius,Color color){
  return BoxDecoration(
    border: Border.all(color: color),
    borderRadius: BorderRadius.only(topRight: Radius.circular(radius),bottomRight: Radius.circular(radius)),
    color: color);  
}



BoxDecoration getBoxDecoDownOnly(double radius,Color color){
  return BoxDecoration(
    border: Border.all(color: color),
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(radius),bottomLeft: Radius.circular(radius)),
    color: color);  
}


BoxDecoration getBoxDecoDownTop(double radius,Color color){
  return BoxDecoration(
    border: Border.all(color: color),
    borderRadius: BorderRadius.only(topRight: Radius.circular(radius),topLeft: Radius.circular(radius)),
    color: color);  
}