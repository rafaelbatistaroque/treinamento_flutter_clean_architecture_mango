import '../../ui/themes/themes.dart';
import '../../ui/pages/pages.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Enquet Mango",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
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
      ),
      home: LoginPage(),
    );
  }
}
