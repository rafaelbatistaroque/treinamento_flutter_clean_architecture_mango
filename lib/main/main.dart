import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import './factories/factories.dart';
import '../../ui/pages/pages.dart';
import '../../ui/components/components.dart';

void main() {
  //Invalida o provider do GETX
  final previous = Provider.debugCheckInvalidValueType;
  Provider.debugCheckInvalidValueType = <T>(value) {
    if (value is LoginPresenter) return;
    previous!<T>(value);
  };

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return GetMaterialApp(
      title: "Enquete Mango",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: makeSplashPage, transition: Transition.fade),
        GetPage(name: "/login", page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(name: "/surveys", page: () => Scaffold(body: Text("Enquestes")), transition: Transition.fadeIn),
      ],
    );
  }
}
