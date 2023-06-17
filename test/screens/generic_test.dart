import 'package:flutter/material.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils.dart';
import '../../lib/services/models/statistic.dart';
import '../../lib/routes/routes.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  testWidgets(
      "Selecting a generic practice should show topic with less correct answer count.",
      (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        {"statistics": await statsStringList()});
    final quizApp = ProviderScope(
        child: MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpWidget(quizApp);
    final interceptor = await getTopics();

    // Shows loading spinner
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(interceptor.isDone, true);

    final prefs = await SharedPreferences.getInstance();
    var strListStats = prefs.getStringList('statistics')!;
    var stat = Statistic.fromSharedPref(strListStats.last);

    int topicId = stat.topicId; // TopicId 3 which has the least correct count
    final interceptor2 = await getQuestion(topicId);
    await tester.tap(find.text("Generic practice"));
    await tester.pumpAndSettle();

    expect(interceptor2.isDone, true);

    expect(find.text("What do you call a dog magician?"), findsOneWidget);
    expect(find.byType(Radio<String>), findsNWidgets(4));

    ["Pomeranian", "Keeshond", "Samoyed", "Labracadabrador"].forEach((option) {
      expect(find.text(option), findsOneWidget);
    });
  });
}
