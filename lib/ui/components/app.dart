import '../../ui/pages/pages.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Enquet Mango",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
