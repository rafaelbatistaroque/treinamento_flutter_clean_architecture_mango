import 'package:flutter/material.dart';
import '../../ui/themes/themes.dart';

ThemeData makeAppTheme() {
  return ThemeData(
    primaryColor: AppColor.primaryColor,
    primaryColorDark: AppColor.primaryColorDark,
    primaryColorLight: AppColor.primaryColorLight,
    accentColor: AppColor.primaryColor,
    backgroundColor: Colors.white,
    textTheme: TextTheme(headline1: AppTextStyles.headline1),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.primaryColorLight),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColor.primaryColor),
      ),
      alignLabelWithHint: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppColor.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: AppColor.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    ),
  );
}
