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
    return ScreenWrapper(FutureBuilder<Question>(
        future: _question,
        builder: (BuildContext context, AsyncSnapshot<Question> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('Select one of the options.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Question question = snapshot.data!;
                final options = List<Widget>.from(
                    question.options.map((option) => (ListTile(
                          title: Text(option),
                          leading: Radio<String>(
                              value: option,
                              groupValue: _selectedOption,
                              onChanged: (String? value) =>
                                  selectAnswerHandler(question, value)),
                        ))));

                return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      SizedBox(
                          height: 100,
                          child: Center(child: Text(question.question))),
                      SizedBox(
                          height: 350,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                question.imageUrl == null
                                    ? const SizedBox.shrink()
                                    : Image(
                                        image:
                                            NetworkImage(question.imageUrl!)),
                                Expanded(child: ListView(children: options)),
                              ])),
                      _correct == null
                          ? const SizedBox.shrink()
                          : _correct == false
                              ? Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      150, 20, 150, 20),
                                  child: const Text(
                                      "Incorrect answer! Please try again"))
                              : Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      150, 20, 150, 20),
                                  child: Row(
                                    children: [
                                      const Text(
                                          "Correct answer! Please choose another question under the same topic"),
                                      const SizedBox(width: 40),
                                      ElevatedButton(
                                          onPressed: fetchNewQuestion,
                                          child: const Text("Choose question"))
                                    ],
                                  ))
                    ]));
              }
            default:
              return const SizedBox.shrink();
          }
        }));
  }
}
