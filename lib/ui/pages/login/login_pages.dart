import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/i18n/i18n.dart';
import '../../components/components.dart';
import './components/components.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (currentFocus.hasPrimaryFocus == false) currentFocus.unfocus();
    }

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading)
              showSpinnerDialog(context);
            else
              hideSpinnerDialog(context);
          });

          presenter.mainErrorStream.listen((error) {
            if (error.isNotEmpty) showErrorMessage(context, error);
          });

          presenter.navigateToStream.listen((page) {
            if (page.isNotEmpty) Get.offAllNamed(page);
          });

          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
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
                      create: (_) => presenter,
                      child: Form(
                        child: Column(
                          children: [
                            EmailInput(),
                            SizedBox(height: 20),
                            PasswordInput(),
                            SizedBox(height: 30),
                            LoginButton(),
                            TextButton.icon(onPressed: () {}, label: Text(R.strings.AddAccount.toUpperCase()), icon: Icon(Icons.person))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
