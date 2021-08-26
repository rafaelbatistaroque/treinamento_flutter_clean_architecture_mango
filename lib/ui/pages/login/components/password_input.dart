import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../../ui/themes/themes.dart';
import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<LoginPresenter>(context);
    return StreamBuilder<String>(
        stream: presenter.passwordErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: presenter.validatePassword,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Senha",
              icon: Icon(Icons.lock, color: AppColor.primaryColorLight),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
          );
        });
  }
}
