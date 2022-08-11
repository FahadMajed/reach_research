import 'dart:convert';

import 'package:reach_research/research.dart';

class Question {
  String questionText;
  bool expectedAnswer;
  bool isCriterionQuestion;
  Criterion? criterion;
  Question({
    this.questionText = "",
    this.expectedAnswer = false,
    this.isCriterionQuestion = false,
    this.criterion,
  });

  factory Question.fromFirestore(Map data) {
    return Question(
        expectedAnswer: data['prefferedAnswer'] ?? false,
        questionText: data['question']);
  }

  Map<String, dynamic> toMap() {
    return {
      'question': questionText,
      'prefferedAnswer': expectedAnswer,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['question'],
      expectedAnswer: map['prefferedAnswer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source));
}
