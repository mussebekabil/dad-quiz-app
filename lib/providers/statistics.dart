import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statisticsFutureProvider = FutureProvider<int>((ref) async {
  return await getStatistics();
});

Future<int> getStatistics() async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('statistics')) {
    return prefs.getInt('statistics')!;
  }

  return 0;
}

incrementStatistics() async {
  final statistics = await getStatistics();
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('statistics', statistics + 1);
}
