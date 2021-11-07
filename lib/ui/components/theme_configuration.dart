import 'package:flutter/material.dart';
import '../../ui/themes/themes.dart';

ThemeData makeAppTheme() {
  var tema = ThemeData();
  return tema.copyWith(
      primaryColorDark: AppColor.primaryColorDark,
      primaryColorLight: AppColor.primaryColorLight,
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
      colorScheme: tema.colorScheme.copyWith(
        secondary: AppColor.primaryColor,
        primary: AppColor.primaryColor,
        background: Colors.white,
      ));
}
