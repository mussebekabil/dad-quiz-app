import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/topic.dart';

class TopicsService {
  Future<List<Topic>> getTopics() async {
    final response =
        await http.get(Uri.parse('https://dad-quiz-api.deno.dev/topics'));
    List<dynamic> data = jsonDecode(response.body);

    final res = List<Topic>.from(data.map(
      (jsonData) => Topic.fromJson(jsonData),
    ));

    return res;
  }

  List<Topic> convertTopicsFromJson(String jsonData) {
    List<dynamic> data = jsonDecode(jsonData);
    return List<Topic>.from(data.map(
      (jsonData) => Topic.fromJson(jsonData),
    ));
  }
}
