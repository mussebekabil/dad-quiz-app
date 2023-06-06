import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/topics.dart';
import '../providers/question.dart';
import '../services/models/topic.dart';
import '../widgets/screen_wrapper.dart';

class TopicsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<Topic>> futureTopics = ref.watch(topicsFutureProvider);

    return ScreenWrapper(futureTopics.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (topics) {
          return Column(children: [
            const SizedBox(
                height: 100, child: Center(child: Text("Choose quiz topic"))),
            Expanded(
                child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: topics.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 256, childAspectRatio: 16),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return Card(
                    child: InkWell(
                  onTap: () => context.push(topic.questionPath),
                  child: Center(child: Text(topic.name)),
                ));
              },
            ))
          ]);
        }));
  }
}
