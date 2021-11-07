import 'package:flutter/material.dart';
import '../../../../main/factories/factories.dart';
import '../../../../ui/pages/pages.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetXSplashPresenter());
}
