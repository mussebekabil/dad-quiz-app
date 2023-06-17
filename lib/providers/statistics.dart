import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/statistic.dart';
import './topics.dart';

class StatisticsNotifier extends StateNotifier<List<String>> {
  StatisticsNotifier() : super([]) {
    _initialize();
  }

  _initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('statistics')) {
      state = prefs.getStringList('statistics')!;
    } else {
      final topics = await fetchTopics(); //ref.watch(topicsFutureProvider);

      state = topics
          .map((topic) => Statistic(topic.id, topic.name, 0).statsAsJson())
          .toList();
    }
  }

  setStatistics(topicId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Statistic> stats =
        state.map((stat) => Statistic.fromSharedPref(stat)).toList();
    stats.forEach((s) => s.topicId == topicId ? s.incrementCount() : s.count);

    stats.sort(((a, b) => b.count.compareTo(a.count)));
    final statStrLst = stats.map((s) => s.statsAsJson()).toList();
    state = statStrLst;
    prefs.setStringList('statistics', statStrLst);
  }

  getTotalCorrectCount() {
    if (state.isEmpty) return 0;
    return state.fold(
        0, (prevValue, s) => prevValue + Statistic.fromSharedPref(s).count);
  }
}

final statisticsProvider =
    StateNotifierProvider<StatisticsNotifier, List<String>>((ref) {
  return StatisticsNotifier();
});
