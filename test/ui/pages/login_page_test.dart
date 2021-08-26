import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/ui/pages/pages.dart';

main() {
  testWidgets("Should load with correct initial state", (WidgetTester tester) async {
    final loginPage = MaterialApp(home: LoginPage());
    await tester.pumpWidget(loginPage);

    final textFormEmail = find.descendant(of: find.bySemanticsLabel("E-mail"), matching: find.byType(Text));
    expect(textFormEmail, findsOneWidget);

    final textFormPassword = find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));
    expect(textFormPassword, findsOneWidget);

    final buttonEntrar = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(buttonEntrar.onPressed, null);
  });
}
