import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/statistics.dart';
import '../widgets/screen_wrapper.dart';

class StatisticsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.refresh(statisticsFutureProvider);
    final statsFuture = ref.watch(statisticsFutureProvider);

    return ScreenWrapper(Column(children: [
      statsFuture.when(
          loading: () => const Text('Loading stats'),
          error: (error, stackTrace) => const Text('Error loading stats'),
          data: (stats) => Text('Total correct answers: $stats')),
      // ElevatedButton(
      //   child: const Text('Go back'),
      //   onPressed: () => () => context.pop('statistics'),
      // )
    ]));
  }
}
