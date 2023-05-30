import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './routes/routes.dart';

main() {
  runApp(ProviderScope(
      child: MaterialApp.router(
    routerConfig: router,
  )));
}
