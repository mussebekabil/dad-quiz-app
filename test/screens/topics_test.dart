import 'package:flutter/material.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import '../../lib/screens/topics.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  testWidgets("Topics screen shows list of topics.", (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final stats = await statsStringList();
    SharedPreferences.setMockInitialValues({"statistics": stats});
    final topicsScreen =
        ProviderScope(child: MaterialApp(home: TopicsScreen()));
    await tester.pumpWidget(topicsScreen);
    final interceptor = await quizMockApi();
    await tester.pump();

    // Shows loading spinner
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

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
