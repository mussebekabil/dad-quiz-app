import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget widget;
  const ScreenWrapper(this.widget, {super.key});
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text("DAD Quiz App"),
          actions: <Widget>[
            TextButton(
              style: style,
              onPressed: () => context.push('/'),
              child: const Text('Home'),
            ),
            TextButton(
              style: style,
              onPressed: () => context.push('/statistics'),
              child: const Text('Statistics'),
            ),
          ],
        ),
        body: Center(child: widget));
  }
}
