import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/statistic.dart';
import './topics.dart';

final statisticsFutureProvider = FutureProvider<List<String>>((ref) async {
  return await getStatistics();
});

Future<List<String>> getStatistics() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('statistics')) {
    return prefs.getStringList('statistics')!;
  }

  final topics = await fetchTopics(); //ref.watch(topicsFutureProvider);
  return topics
      .map((topic) => Statistic(topic.id, topic.name, 0).statsAsJson())
      .toList();
}

setStatistics(topicId) async {
  final statsStr = await getStatistics();
  final prefs = await SharedPreferences.getInstance();

  List<Statistic> stats =
      statsStr.map((stat) => Statistic.fromSharedPref(stat)).toList();
  stats.forEach((s) => s.topicId == topicId ? s.incrementCount() : s.count);

  stats.sort(((a, b) => b.count.compareTo(a.count)));

  prefs.setStringList('statistics', stats.map((s) => s.statsAsJson()).toList());
}
