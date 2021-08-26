import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/components.dart';
import '../../themes/themes.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter? presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter!.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => SimpleDialog(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Aguarde...",
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
                        ],
                      ));
            } else {
              if (Navigator.canPop(context)) Navigator.of(context).pop();
            }
          });

          return SingleChildScrollView(
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
                        StreamBuilder<String>(
                            stream: presenter!.emailErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  onChanged: presenter!.validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "E-mail",
                                    icon: Icon(Icons.email, color: AppColor.primaryColorLight),
                                    errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                                  ));
                            }),
                        SizedBox(height: 20),
                        StreamBuilder<String>(
                            stream: presenter!.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                onChanged: presenter!.validatePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Senha",
                                  icon: Icon(Icons.lock, color: AppColor.primaryColorLight),
                                  errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                                ),
                              );
                            }),
                        SizedBox(height: 30),
                        StreamBuilder<bool>(
                            stream: presenter!.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true ? presenter!.auth : null,
                                child: Text("Entrar".toUpperCase()),
                              );
                            }),
                        TextButton.icon(onPressed: () {}, label: Text("Entrar".toUpperCase()), icon: Icon(Icons.person))
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
