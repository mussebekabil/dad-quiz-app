import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/answer.dart';

class AnswerService {
  Future<bool> submitAnswer(String path, String answer) async {
    var response = await http.post(
        Uri.parse('https://dad-quiz-api.deno.dev$path'),
        body: jsonEncode({"answer": answer}));
    var data = jsonDecode(response.body);

    return data['correct'];
  }
}
