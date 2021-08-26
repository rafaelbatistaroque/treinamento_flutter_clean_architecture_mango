import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/components.dart';
import '../../themes/themes.dart';
import 'login_presenter.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage(this.presenter);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter!.isLoadingStream.listen((isLoading) {
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

          widget.presenter!.mainErrorStream.listen((error) {
            if (error.isEmpty == false) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red[900],
                content: Text(
                  error,
                  textAlign: TextAlign.center,
                ),
              ));
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
                            stream: widget.presenter!.emailErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                  onChanged: widget.presenter!.validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: "E-mail",
                                    icon: Icon(Icons.email, color: AppColor.primaryColorLight),
                                    errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                                  ));
                            }),
                        SizedBox(height: 20),
                        StreamBuilder<String>(
                            stream: widget.presenter!.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                onChanged: widget.presenter!.validatePassword,
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
                            stream: widget.presenter!.isFormValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true ? widget.presenter!.auth : null,
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
