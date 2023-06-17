import 'package:flutter/material.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import '../../lib/services/answer.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  test("Answer service checks if question is answered correctly", () async {
    WidgetsFlutterBinding.ensureInitialized();
    // Question is "What is the outcome of 3 + 3?"
    String answerPath = "/topics/1/questions/4/answers";

    final interceptor = submitAnswer(answerPath, "9");
    final response = await AnswerService().submitAnswer(answerPath, "9");

    expect(interceptor.isDone, true);
    expect(response, false);

    submitAnswer(answerPath, "6");
    final response2 = await AnswerService().submitAnswer(answerPath, "6");

    expect(response2, true);
  });
}
