class Topic {
  int id;
  String name;
  String questionPath;

  Topic(this.id, this.name, this.questionPath);

  Topic.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        name = jsonData['name'],
        questionPath = jsonData['question_path'];
}
