import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/topics.dart';
import '../services/models/question.dart';
import '../services/question.dart';

class QuestionNotifier extends StateNotifier<Question> {
  final questionApi = QuestionService();
  QuestionNotifier() : super(Question(0, "", [], ""));

  getQuestion(String topicId) async {
    state = await questionApi.getTopicQuestion(topicId);
  }
}

final questionProvider =
    StateNotifierProvider<QuestionNotifier, Question>((ref) {
  final qn = QuestionNotifier();
  return qn;
});
