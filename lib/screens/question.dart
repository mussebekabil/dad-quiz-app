import 'package:dad_quiz_api/services/answer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/question.dart';
import '../services/models/statistic.dart';
import '../services/question.dart';
import '../widgets/screen_wrapper.dart';
import '../providers/statistics.dart';

class QuestionScreen extends StatefulWidget {
  final int topicId;
  final bool practice;
  QuestionScreen(this.topicId, this.practice);

  @override
  State<QuestionScreen> createState() =>
      _QuestionScreenState(topicId, practice);
}

class _QuestionScreenState extends State<QuestionScreen> {
  final int _topicId;
  final bool practice;
  Future<Question> _question;
  String? _selectedOption;
  bool? _correct;

  _QuestionScreenState(this._topicId, this.practice)
      : _question = QuestionService().getTopicQuestion(_topicId);

  fetchNewQuestion() async {
    int nextTopicId = _topicId;
    if (practice == true) {
      final asyncStats = await getStatistics();
      List<Statistic> stats =
          asyncStats.map((s) => Statistic.fromSharedPref(s)).toList();
      nextTopicId = stats.last.topicId;
    }

    setState(() {
      _question = QuestionService().getTopicQuestion(nextTopicId);
      _selectedOption = null;
      _correct = null;
    });
  }

  selectAnswerHandler(question, value) {
    AnswerService().submitAnswer(question.answerPath, value!).then((correct) {
      if (correct == true) {
        setStatistics(_topicId);
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
                      Container(
                          height: 350,
                          padding: const EdgeInsets.fromLTRB(150, 20, 150, 20),
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
