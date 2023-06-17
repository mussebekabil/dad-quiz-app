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
      "Selecting a topic without images shows a question for that topic.",
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

    int topicId = 1;
    final interceptor2 = await getQuestion(topicId);
    await tester.tap(find.text("Basic arithmetics")); // TopicId 1
    await tester.pumpAndSettle();

    expect(interceptor2.isDone, true);
    expect(find.text("What is the outcome of 3 + 3?"), findsOneWidget);
    expect(find.byType(Radio<String>), findsNWidgets(5));

    ["100", "49", "200", "95", "6"].forEach((option) {
      expect(find.text(option), findsOneWidget);
    });

    // Selecting wrong answer should show Incorrect message
    submitAnswer("/topics/1/questions/4/answers", "200");
    await tester.tap(find.text("200"));
    await tester.pumpAndSettle();

    expect(find.text("Incorrect answer! Please try again"), findsOneWidget);

    // Selecting correct answer should submit answer and update statistics,
    // Show correct message and choose another question button
    final prefs = await SharedPreferences.getInstance();
    var strListStats = prefs.getStringList('statistics')!;
    var stat = Statistic.fromSharedPref(strListStats[0]);

    // Initial stats for the current question
    expect(stat.topicId, topicId);
    expect(stat.topicName, "Basic arithmetics");
    expect(stat.count, 4);
    submitAnswer("/topics/1/questions/4/answers", "6");
    await tester.tap(find.text("6"));
    await tester.pumpAndSettle();

    final nextQuestionBtn = find.byKey(const ValueKey("chooseNextQuestion"));

    expect(
        find.text(
            "Correct answer! Please choose another question under the same topic"),
        findsOneWidget);
    expect(find.text("Choose question"), findsOneWidget);

    strListStats = prefs.getStringList('statistics')!;
    stat = Statistic.fromSharedPref(strListStats[0]);

    // updated stats for the current question
    expect(stat.topicId, topicId);
    expect(stat.topicName, "Basic arithmetics");
    expect(stat.count, 5);

    // Tap Choose question should fetch new question set from the same topic
    // final interceptor3 = await getQuestion(topicId, nextQuestion: true);

    // await tester.dragUntilVisible(
    //   nextQuestionBtn, // what you want to find
    //   find.byType(SingleChildScrollView), // widget you want to scroll
    //   const Offset(0, -500), // delta to move
    // );

    // await tester.press(nextQuestionBtn);
    // await tester.pumpAndSettle();
    // expect(interceptor3.isDone, true);
    // expect(find.text("What is the outcome of 3 + 3?"), findsNothing);
    // expect(find.text("What is the outcome of 100 + 100?"), findsOneWidget);

    // ["6", "20", "10", "200", "8"].forEach((option) {
    //   expect(find.text(option), findsOneWidget);
    // });
  });
}
