import 'package:flutter/material.dart';
import 'package:office_expense_manager/Pages/splash_screen.dart';

class Constants{
  final  backgroundColor = const Color(0xffEEE7CE);
  final  deepTealColor = const Color(0xff064439);

  ThemeData myTheme = ThemeData(
    fontFamily: "customFont",
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontFamily: "customFont",
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}