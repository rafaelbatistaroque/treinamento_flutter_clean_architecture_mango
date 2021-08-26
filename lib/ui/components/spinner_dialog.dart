import 'package:flutter/material.dart';

void showSpinnerDialog(BuildContext context) {
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
}

void hideSpinnerDialog(BuildContext context) {
  if (Navigator.canPop(context)) Navigator.of(context).pop();
}
