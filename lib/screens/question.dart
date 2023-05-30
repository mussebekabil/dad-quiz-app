import 'package:dad_quiz_api/services/answer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/question.dart';
import '../services/question.dart';
import '../widgets/screen_wrapper.dart';
import '../providers/statistics.dart';

class QuestionScreen extends StatefulWidget {
  final String topicId;
  QuestionScreen(this.topicId);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState(topicId);
}

class _QuestionScreenState extends State<QuestionScreen> {
  final String _topicId;
  Future<Question> _question;
  String? _selectedOption;
  bool? _correct;

  _QuestionScreenState(this._topicId)
      : _question = QuestionService().getTopicQuestion(_topicId);

  fetchNewQuestion() {
    setState(() {
      _question = QuestionService().getTopicQuestion(_topicId);
      _selectedOption = null;
      _correct = null;
    });
  }

  selectAnswerHandler(question, value) {
    AnswerService().submitAnswer(question.answerPath, value!).then((correct) {
      if (correct == true) {
        incrementStatistics();
      }
      setState(() {
        _correct = correct;
        _selectedOption = value;
      });
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return FutureBuilder<Question>(
        future: _question,
        builder: (BuildContext context, AsyncSnapshot<Question> snapshot) {
          if (snapshot.hasError) {
            return Expanded(
                child: Text("Error in retrieving question: ${snapshot.error}"));
          } else {
            Question question = snapshot.data!;
            print(question);
            final options =
                List<Widget>.from(question.options.map((option) => (ListTile(
                      title: Text(option),
                      leading: Radio<String>(
                          value: option,
                          groupValue: _selectedOption,
                          onChanged: (String? value) =>
                              selectAnswerHandler(question, value)),
                    ))));

            return ScreenWrapper(Column(children: [
              Text(question.question),
              Expanded(child: ListView(children: options)),
              _correct == null
                  ? const SizedBox.shrink()
                  : _correct == false
                      ? const Text("Incorrect answer! please try again")
                      : Row(children: [
                          const Text(
                              "Correct answer! please choose another question"),
                          ElevatedButton(
                              onPressed: fetchNewQuestion,
                              child: const Text("Choose question"))
                        ])
            ]));
          }
        });
  }
}
