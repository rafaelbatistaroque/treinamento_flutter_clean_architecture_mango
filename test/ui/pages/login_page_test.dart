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
  late StreamController<bool> isFormValidController;
  late StreamController<bool> isLoadingController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    when(() => presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
    when(() => presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
    when(() => presenter.isFormValidStream).thenAnswer((_) => isFormValidController.stream);
    when(() => presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
  });

  testWidgets("Should load with correct initial state", (WidgetTester tester) async {
    await loadPage(tester);

    final textFormEmail = find.descendant(of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text));
    expect(textFormEmail, findsOneWidget);

    final textFormPassword = find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));
    expect(textFormPassword, findsOneWidget);

    final buttonEntrar = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonEntrar.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
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

  testWidgets("Should present no error if password is valid", (WidgetTester tester) async {
    await loadPage(tester);

    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should present no error if password is valid", (WidgetTester tester) async {
    await loadPage(tester);

    passwordErrorController.add("");
    await tester.pump();

    expect(
      find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets("Should enable button if form is valid", (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();

    final buttonEntrar = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonEntrar.onPressed, isNotNull);
  });

  testWidgets("Should disable button if form is invalid", (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(false);
    await tester.pump();

    final buttonEntrar = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonEntrar.onPressed, isNull);
  });

  testWidgets("Should call authentication on form submit", (WidgetTester tester) async {
    await loadPage(tester);

    isFormValidController.add(true);
    await tester.pump();
    tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed!();
    await tester.pump();

    verify(() => presenter.auth()).called(1);
  });

  testWidgets("Should present loading", (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Should hide loading", (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
