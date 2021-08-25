import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image(image: AssetImage("./lib/ui/assets/logo.png")),
            ),
            Text("Login".toUpperCase()),
            Form(
                child: Column(
              children: [
                TextFormField(decoration: InputDecoration(labelText: "E-mail", icon: Icon(Icons.email)), keyboardType: TextInputType.emailAddress),
                TextFormField(decoration: InputDecoration(labelText: "Senha", icon: Icon(Icons.lock)), obscureText: true),
                ElevatedButton(onPressed: () {}, child: Text("Entrar".toUpperCase())),
                TextButton.icon(onPressed: () {}, label: Text("Entrar".toUpperCase()), icon: Icon(Icons.person))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
