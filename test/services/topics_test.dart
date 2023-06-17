import 'package:flutter/material.dart';
import 'package:nock/nock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils.dart';
import '../../lib/providers/topics.dart';
import '../../lib/services/models/topic.dart';

void main() {
  setUpAll(() {
    nock.init();
  });

  setUp(() {
    nock.cleanAll();
  });

  test("Topics service fetch topics correctly", () async {
    WidgetsFlutterBinding.ensureInitialized();
    final interceptor = await getTopics();
    final topics = await fetchTopics();

    expect(interceptor.isDone, true);
    expect(topics.length, 3);
    expect(topics, isA<List<Topic>>());
  });
}
