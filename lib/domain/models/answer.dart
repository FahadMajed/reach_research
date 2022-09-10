class Answer {
  final bool myAnswer;
  final bool expectedAnswer;
  final String question;
  Answer({
    required this.myAnswer,
    required this.expectedAnswer,
    required this.question,
  });

  Map<String, dynamic> toMap() {
    return {
      'myAnswer': myAnswer,
      'acctualAnswer': expectedAnswer,
      'question': question,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      myAnswer: map['myAnswer'],
      expectedAnswer: map['expectedAnswer'],
      question: map['question'],
    );
  }

  factory Answer.empty() => Answer(
        myAnswer: false,
        expectedAnswer: false,
        question: "",
      );
}
