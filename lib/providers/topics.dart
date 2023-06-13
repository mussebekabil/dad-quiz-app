import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/topic.dart';
import '../services/models/statistic.dart';
import '../services/topics.dart';
import 'statistics.dart';

Future<List<Topic>> fetchTopics() async {
  final topicApi = TopicsService();

  return await topicApi.getTopics();
}

final topicsFutureProvider = FutureProvider<List<Topic>>((ref) async {
  final statsProvider = ref.watch(statisticsProvider);
  final topics = await fetchTopics();

  if (statsProvider.isEmpty) return topics;

  List<Statistic> stats =
      statsProvider.map((s) => Statistic.fromSharedPref(s)).toList();
  final practiceTopic = topics.firstWhere((t) => t.id == stats.last.topicId);
  return topics
    ..add(Topic(
        practiceTopic.id, "Generic practice", practiceTopic.questionPath));
});
