import 'dart:convert';

import 'package:dad_quiz_api/services/models/statistic.dart';
import 'package:dad_quiz_api/services/models/topic.dart';
import 'package:dad_quiz_api/services/topics.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nock/nock.dart';

Future<String> fetchJsonMock(String path) async =>
    await rootBundle.loadString(path);

Future<List<Topic>> topicsResponse() async {
  final jsonData = await fetchJsonMock('mocks/topics_response.json');
  final topicApi = TopicsService();
  return topicApi.convertTopicsFromJson(jsonData);
}

quizMockApi() async => nock("https://dad-quiz-api.deno.dev").get("/topics")
  ..reply(
    200,
    await fetchJsonMock('mocks/topics_response.json'),
  );

statsStringList() async {
  final statStr = await fetchJsonMock('mocks/stats_response.json');
  List<dynamic> data = jsonDecode(statStr);
  return List<String>.from(data.map(
    (jsonData) => json.encode(jsonData),
  ));
}
