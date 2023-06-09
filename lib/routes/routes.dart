import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/topics.dart';
import '../screens/question.dart';
import '../screens/statistics.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => TopicsScreen()),
    GoRoute(
        path: '/statistics', builder: (context, state) => StatisticsScreen()),
    GoRoute(
        name: 'questions',
        path: '/topics/:topicId/questions',
        builder: (context, state) => QuestionScreen(
              int.parse(state.params['topicId']!),
              state.queryParams['practice']! == "true" ? true : false,
            )),
  ],
);
