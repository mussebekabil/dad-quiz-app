import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './routes/routes.dart';
import './providers/statistics.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
      // overrides: [
      //   sharedPreferencesProvider.overrideWithValue(prefs),
      // ],
      child: MaterialApp.router(
    routerConfig: router,
  )));
}
