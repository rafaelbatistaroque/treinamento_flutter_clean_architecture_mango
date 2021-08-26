import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';
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
            if (isLoading)
              showSpinnerDialog(context);
            else
              hideSpinnerDialog(context);
          });

          widget.presenter!.mainErrorStream.listen((error) {
            if (error.isEmpty == false) showErrorMessage(context, error);
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
                  child: Provider<LoginPresenter>(
                    create: (_) => widget.presenter!,
                    child: Form(
                      child: Column(
                        children: [
                          EmailInput(),
                          SizedBox(height: 20),
                          PasswordInput(),
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
