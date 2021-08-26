import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../lib/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {
  late LoginPresenterSpy presenter;
  late StreamController<String> emailErrorController;
  late StreamController<String> passwordErrorController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    when(() => presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
  });

  testWidgets("Should load with correct initial state", (WidgetTester tester) async {
    await loadPage(tester);

    final textFormEmail = find.descendant(of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text));
    expect(textFormEmail, findsOneWidget);

    final textFormPassword = find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));
    expect(textFormPassword, findsOneWidget);

    final buttonEntrar = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonEntrar.onPressed, null);
  });

  testWidgets("Should call validate with correct values", (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel("E-mail"), email);
    verify(() => presenter.validateEmail(email)).called(1);

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel("Senha"), password);
    verify(() => presenter.validatePassword(password)).called(1);
  });

  testWidgets("Should present error if email is invalid", (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add("any arror");
    await tester.pump();

    expect(find.text("any arror"), findsOneWidget);
  });

  testWidgets("Should present no error if email is valid", (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should present no error if email is valid", (WidgetTester tester) async {
    await loadPage(tester);

    emailErrorController.add("");
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should present error if password is invalid", (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add("any arror");
    await tester.pump();

    expect(find.text("any arror"), findsOneWidget);
  });
}
