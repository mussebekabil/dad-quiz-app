import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/statistics.dart';
import '../services/models/statistic.dart';
import '../widgets/screen_wrapper.dart';

class StatisticsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(statisticsFutureProvider);
    final statsFuture = ref.watch(statisticsFutureProvider);

    return ScreenWrapper(Column(children: [
      const SizedBox(
          height: 80,
          child: Center(child: Text('Total correct answers by topic'))),
      statsFuture.when(
          loading: () => const Text('Loading stats'),
          error: (error, stackTrace) => const Text('Error loading stats'),
          data: (stats) {
            return Container(
                height: 400,
                padding: const EdgeInsets.fromLTRB(150, 20, 150, 20),
                child: Column(children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      final stat = Statistic.fromSharedPref(stats[index]);
                      return Card(
                        child: ListTile(
                          title: Text(stat.topicName),
                          trailing: Text("${stat.count}"),
                        ),
                      );
                    },
                  ))
                ]));
          }),
    ]));
  }
}
