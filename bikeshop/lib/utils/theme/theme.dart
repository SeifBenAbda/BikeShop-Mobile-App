import 'package:flutter/material.dart';

const Color bgColor = Color(0xFF121213);
final ThemeData theme = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      shadowColor: bgColor,
      foregroundColor: bgColor,
      backgroundColor: bgColor,
      elevation: 0.0,
      surfaceTintColor: bgColor,
     // color: bgColor
    ),
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      background: bgColor,
      onBackground: Colors.white,
      surfaceTint: bgColor,
      primary: Colors.white,
      onPrimary: bgColor,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 55,
      indicatorColor: Colors.transparent,
      elevation: 5.0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      backgroundColor: bgColor,
      iconTheme: MaterialStatePropertyAll<IconThemeData>(
        IconThemeData(
          color: Colors.white,
          size: 30,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        foregroundColor: MaterialStateProperty.all(bgColor),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
      backgroundColor:
          MaterialStateProperty.all<Color>(bgColor),
      minimumSize: MaterialStateProperty.all(Size.zero),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
    )));
