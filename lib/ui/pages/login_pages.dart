import 'package:flutter/material.dart';

import '../../ui/components/components.dart';
import '../../ui/themes/themes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginHeader(),
            Text(
              "Login".toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                        decoration: InputDecoration(labelText: "E-mail", icon: Icon(Icons.email, color: AppColor.primaryColorLight)),
                        keyboardType: TextInputType.emailAddress),
                    SizedBox(height: 20),
                    TextFormField(
                        decoration: InputDecoration(labelText: "Senha", icon: Icon(Icons.lock, color: AppColor.primaryColorLight)),
                        obscureText: true),
                    SizedBox(height: 30),
                    ElevatedButton(onPressed: () {}, child: Text("Entrar".toUpperCase())),
                    TextButton.icon(onPressed: () {}, label: Text("Entrar".toUpperCase()), icon: Icon(Icons.person))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
