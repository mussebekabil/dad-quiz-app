import 'dart:convert';

import 'package:dad_quiz_api/services/models/statistic.dart';
import 'package:dad_quiz_api/services/models/topic.dart';
import 'package:dad_quiz_api/services/topics.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nock/nock.dart';

const BASE_URL = "https://dad-quiz-api.deno.dev";
Future<String> fetchJsonMock(String path) async =>
    await rootBundle.loadString(path);

Future<List<Topic>> topicsResponse() async {
  final jsonData = await fetchJsonMock('mocks/topics_response.json');
  final topicApi = TopicsService();
  return topicApi.convertTopicsFromJson(jsonData);
}

getTopics() async => nock(BASE_URL).get("/topics")
  ..reply(
    200,
    await fetchJsonMock('mocks/topics_response.json'),
  );

getQuestion(int topicId, {bool nextQuestion = false}) {
  switch (topicId) {
    case 1:
      if (nextQuestion) {
        return nock(BASE_URL).get("/topics/1/questions")
          ..reply(200, {
            "id": 2,
            "question": "What is the outcome of 100 + 100?",
            "options": ["6", "20", "10", "200", "8"],
            "answer_post_path": "/topics/1/questions/2/answers"
          });
      }
      return nock(BASE_URL).get("/topics/1/questions")
        ..reply(200, {
          "id": 4,
          "question": "What is the outcome of 3 + 3?",
          "options": ["100", "49", "200", "95", "6"],
          "answer_post_path": "/topics/1/questions/4/answers"
        });

    case 3:
      return nock(BASE_URL).get("/topics/3/questions")
        ..reply(200, {
          "id": 4,
          "question": "What do you call a dog magician?",
          "options": ["Pomeranian", "Keeshond", "Samoyed", "Labracadabrador"],
          "answer_post_path": "/topics/4/questions/4/answers"
        });
    case 2:
    default:
      return nock(BASE_URL).get("/topics/2/questions")
        ..reply(200, {
          "id": 4,
          "question": "What is the capital of Andorra?",
          "options": ["Luanda", "Andorra la Vella", "Vienna", "Tirana"],
          "answer_post_path": "/topics/2/questions/4/answers"
        });
  }
}

submitAnswer(String path, String answer) {
  if (answer == "6") {
    return nock(BASE_URL).post(path, jsonEncode({"answer": answer}))
      ..reply(201, {"correct": true});
  }
  return nock(BASE_URL).post(path, jsonEncode({"answer": answer}))
    ..reply(201, {"correct": false});
}

statsStringList() async {
  final statStr = await fetchJsonMock('mocks/stats_response.json');
  List<dynamic> data = jsonDecode(statStr);
  return List<String>.from(data.map(
    (jsonData) => json.encode(jsonData),
  ));
}
