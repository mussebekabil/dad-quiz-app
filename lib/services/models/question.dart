class Question {
  int id;
  String question;
  List<String> options;
  String answerPath;
  String? imageUrl;

  Question(
      this.id, this.question, this.options, this.answerPath, this.imageUrl);
}
