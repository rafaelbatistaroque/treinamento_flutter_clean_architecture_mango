import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      appBar: AppBar(title: Text("4Dev")),
      body: Builder(builder: (context) {
        presenter.navigateToStream.listen((page) {
          if (page.isNotEmpty == true) Get.offAllNamed(page);
        });
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

abstract class SplashPresenter {
  Stream<String> get navigateToStream;
  Future<void> loadCurrentAccount();
}

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenterSpy presenter;
  late StreamController<String> navigateToController;

  When mockNavigate() => when(() => presenter.navigateToStream);
  When mockLoadPage() => when(() => presenter.loadCurrentAccount());

  setUp(() {
    presenter = SplashPresenterSpy();
    navigateToController = StreamController<String>();
    mockLoadPage().thenAnswer((_) async => "");
    mockNavigate().thenAnswer((_) => navigateToController.stream);
  });

  tearDown(() {
    navigateToController.close();
  });

  Future<void> loadPage(WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => SplashPage(presenter: presenter)),
        GetPage(name: "/any_route", page: () => Scaffold(body: Text("fake page"))),
      ],
    ));
  }

  testWidgets("Should present spinner on page load", (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets("Should call loadCurrentAccount on page load", (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadCurrentAccount()).called(1);
  });

  testWidgets("Should change page", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add("/any_route");
    await tester.pumpAndSettle();

    expect(Get.currentRoute, "/any_route");
    expect(find.text("fake page"), findsOneWidget);
  });

  testWidgets("Should not change page", (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add("");
    await tester.pump();

    expect(Get.currentRoute, "/");
  });
}
