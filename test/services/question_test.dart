import 'package:dad_quiz_api/services/question.dart';
import 'package:flutter/material.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import '../../lib/providers/question.dart';
import '../../lib/services/models/question.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  test("Question service fetch question by topic id correctly", () async {
    WidgetsFlutterBinding.ensureInitialized();
    int topicId = 1;
    final interceptor = getQuestion(topicId);
    final response = await QuestionService().getTopicQuestion(topicId);

    expect(interceptor.isDone, true);
    expect(response.id, 4);
    expect(response.question, "What is the outcome of 3 + 3?");
    expect(response.options, ["100", "49", "200", "95", "6"]);
    expect(response.answerPath, "/topics/1/questions/4/answers");
  });
}
