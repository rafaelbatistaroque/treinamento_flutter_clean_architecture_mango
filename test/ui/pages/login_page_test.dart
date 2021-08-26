import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../lib/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

main() {
  late LoginPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

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
}
