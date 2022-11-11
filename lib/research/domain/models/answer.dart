import 'package:reach_core/core/core.dart';

class Answer extends Equatable {
  final bool myAnswer;
  final bool expectedAnswer;
  final String question;
  final String researchId;
  const Answer({
    required this.myAnswer,
    required this.expectedAnswer,
    required this.question,
    this.researchId = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'myAnswer': myAnswer,
      'researchId': researchId,
      'expectedAnswer': expectedAnswer,
      'question': question,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      researchId: map['researchId'] ?? "",
      myAnswer: map['myAnswer'],
      expectedAnswer: map['expectedAnswer'],
      question: map['question'],
    );
  }

  factory Answer.empty() => const Answer(
        myAnswer: false,
        expectedAnswer: false,
        question: "",
        researchId: "",
      );

  @override
  List<Object?> get props => [myAnswer, question];

  Answer copyWith({
    bool? myAnswer,
    bool? expectedAnswer,
    String? question,
    String? researchId,
  }) {
    return Answer(
      myAnswer: myAnswer ?? this.myAnswer,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
      question: question ?? this.question,
      researchId: researchId ?? this.researchId,
    );
  }
}
