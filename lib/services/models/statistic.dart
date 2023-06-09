import 'dart:convert';

class Statistic {
  final int topicId;
  final String topicName;
  int count;

  Statistic(this.topicId, this.topicName, this.count);

  factory Statistic.fromSharedPref(String data) {
    Map<String, dynamic> dataMap = jsonDecode(data) as Map<String, dynamic>;
    return Statistic(
        dataMap['topicId'], dataMap['topicName'], dataMap['count']);
  }

  String statsAsJson() {
    return jsonEncode(
        {'topicId': topicId, 'topicName': topicName, 'count': count});
  }

  void incrementCount() {
    count++;
  }
}
