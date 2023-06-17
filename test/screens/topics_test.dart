import 'package:flutter/material.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import '../../lib/routes/routes.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  testWidgets("Opening the application shows the list of topics.",
      (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final stats = await statsStringList();
    SharedPreferences.setMockInitialValues({"statistics": stats});
    final quizApp = ProviderScope(
        child: MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpWidget(quizApp);
    final interceptor = await getTopics();

    // Shows loading spinner and page title
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text("DAD Quiz App"), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));

    await tester.pumpAndSettle();

    expect(interceptor.isDone, true);
    final topicTitles = [
      "Basic arithmetics",
      "Countries and capitals",
      "Dog breeds"
    ];

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text("Choose quiz topic"), findsOneWidget);

    topicTitles.forEach((title) {
      expect(find.text(title), findsOneWidget);
    });

    // Test generic practice option is visible
    expect(find.byType(Card), findsNWidgets(4));
    expect(find.text("Generic practice"), findsOneWidget);
  });
}
