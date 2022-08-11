import 'dart:convert';

class Answer {
  final bool myAnswer;
  final bool actualAnswer;
  final String question;
  Answer({
    required this.myAnswer,
    required this.actualAnswer,
    required this.question,
  });

  Map<String, dynamic> toMap() {
    return {
      'myAnswer': myAnswer,
      'acctualAnswer': actualAnswer,
      'question': question,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      myAnswer: map['myAnswer'],
      actualAnswer: map['acctualAnswer'],
      question: map['question'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Answer.fromJson(String source) => Answer.fromMap(json.decode(source));

  @override
  String toString() =>
      'Answer(myAnswer: $myAnswer, acctualAnswer: $actualAnswer, question: $question)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Answer &&
        other.myAnswer == myAnswer &&
        other.actualAnswer == actualAnswer &&
        other.question == question;
  }

  @override
  int get hashCode =>
      myAnswer.hashCode ^ actualAnswer.hashCode ^ question.hashCode;
}
