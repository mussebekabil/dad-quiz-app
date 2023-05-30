import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/topic.dart';
import '../services/topics.dart';

class TopicsNotifier extends StateNotifier<List<Topic>> {
  final topicApi = TopicsService();
  TopicsNotifier() : super([]);

  _initialize() async {
    state = await topicApi.getTopics();
  }
}

final topicsProvider =
    StateNotifierProvider<TopicsNotifier, List<Topic>>((ref) {
  final tn = TopicsNotifier();
  tn._initialize();
  return tn;
});
