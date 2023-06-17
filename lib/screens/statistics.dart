import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/statistics.dart';
import '../services/models/statistic.dart';
import '../widgets/screen_wrapper.dart';

class StatisticsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsFuture = ref.watch(statisticsProvider);
    int totalCorrect =
        ref.watch(statisticsProvider.notifier).getTotalCorrectCount();

    return ScreenWrapper(Column(children: [
      SizedBox(
          height: 60,
          child: Center(child: Text('Total correct answers ${totalCorrect}'))),
      const SizedBox(
          height: 60,
          child: Center(child: Text('Total correct answers by topic'))),
      Container(
          height: 350,
          padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
          child: Column(children: [
            Expanded(
                child: ListView.builder(
              itemCount: statsFuture.length,
              itemBuilder: (context, index) {
                final stat = Statistic.fromSharedPref(statsFuture[index]);
                return Card(
                  child: ListTile(
                    key: Key("stat-${stat.topicId}"),
                    title: Text(stat.topicName),
                    trailing: Text("${stat.count}"),
                  ),
                );
              },
            ))
          ]))
    ]));
  }
}
