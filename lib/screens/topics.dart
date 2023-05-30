import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/topics.dart';
import '../widgets/screen_wrapper.dart';

class TopicsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider);
    if (topics.isEmpty) {
      return const ScreenWrapper(Text("No topics available"));
    }
    final items = List<Widget>.from(topics.map(
      (topic) => ElevatedButton(
        onPressed: () => context.push(topic.questionPath),
        child: Text(topic.name),
      ),
    ));
    return ScreenWrapper(Column(children: items));
    // final items = List<Widget>.from(topics.map(
    //   (topic) => ListTile(
    //     title: Text(topic.name),
    //     subtitle: Text(topic.questionPath),
    //   ),
    // ));
    // return ScreenWrapper(Expanded(child: ListView(children: items)));
  }
}
