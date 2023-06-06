import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/question.dart';

class QuestionService {
  Future<Question> getTopicQuestion(String topicId) async {
    var response = await http.get(
        Uri.parse('https://dad-quiz-api.deno.dev/topics/$topicId/questions'));
    var data = jsonDecode(response.body);

    List<String> options =
        List<String>.from(data['options'].map((item) => item.toString()));

    return Question(data['id'], data['question'], options,
        data['answer_post_path'], data['image_url']);
  }
}
