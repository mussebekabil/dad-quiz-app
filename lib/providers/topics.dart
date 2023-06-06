import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/models/topic.dart';
import '../services/topics.dart';

Future<List<Topic>> fetchTopics() async {
  final topicApi = TopicsService();

  return await topicApi.getTopics();
}

final topicsFutureProvider =
    FutureProvider<List<Topic>>((ref) async => await fetchTopics());
