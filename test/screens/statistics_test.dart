import 'package:dad_quiz_api/services/models/statistic.dart';
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

  testWidgets("Should show statistics page correctly.", (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final stats = await statsStringList();
    SharedPreferences.setMockInitialValues({"statistics": stats});
    final quizApp = ProviderScope(
        child: MaterialApp.router(
      routerConfig: router,
    ));

    await getTopics();
    await tester.pumpWidget(quizApp);
    await tester.pumpAndSettle();

    expect(find.text("DAD Quiz App"), findsOneWidget);

    final statsBtn = find.text("Statistics");
    expect(statsBtn, findsOneWidget);
    await tester.tap(statsBtn);
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    var strListStats = prefs.getStringList('statistics')!;
    var statsLst =
        strListStats.map((stat) => Statistic.fromSharedPref(stat)).toList();

    // total correct answer count matches data stored in SharedPreferences.
    int total = statsLst.fold(0, ((prevValue, s) => prevValue + s.count));
    expect(find.text("Total correct answers $total"), findsOneWidget);

    // topic-specific correct answer counts match data stored in SharedPreferences
    expect(find.byType(Card), findsNWidgets(3));
    statsLst.forEach((stat) {
      final listTile = find.byKey(Key("stat-${stat.topicId}"));
      expect(find.descendant(of: listTile, matching: find.text(stat.topicName)),
          findsOneWidget);
      expect(
          find.descendant(of: listTile, matching: find.text("${stat.count}")),
          findsOneWidget);
    });
  });
}
