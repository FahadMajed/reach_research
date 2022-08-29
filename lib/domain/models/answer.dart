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

  factory Answer.empty() => Answer(
        myAnswer: false,
        actualAnswer: false,
        question: "",
      );
}
