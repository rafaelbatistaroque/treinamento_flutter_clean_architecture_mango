import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import './factories/factories.dart';
import '../../ui/components/components.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return GetMaterialApp(
      title: "Enquet Mango",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/login", page: makeLoginPage),
      ],
    );
  }
}
