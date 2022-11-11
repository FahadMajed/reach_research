import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class Question extends Equatable {}

class CustomizedQuestion extends Question {
  final bool expectedAnswer;
  final String questionText;

  CustomizedQuestion({
    required this.questionText,
    required this.expectedAnswer,
  });

  @override
  List<Object?> get props => [questionText, expectedAnswer];

  CustomizedQuestion copyWith({
    bool? expectedAnswer,
    String? questionText,
  }) {
    return CustomizedQuestion(
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
      questionText: questionText ?? this.questionText,
    );
  }
}

class CriterionQuestion extends Question {
  final Criterion criterion;
  late final String questionText;
  CriterionQuestion({
    required this.criterion,
  }) {
    if (criterion is RangeCriterion) {
      final range = criterion as RangeCriterion;
      questionText = "Is your ${criterion.name} is between ${range.from} and ${range.to}?";
    } else {
      final condition = (criterion as ValueCriterion).condition;
      if (criterion.name == "gender") {
        questionText = "Are you $condition";
      } else {
        questionText = "Are you from $condition";
      }
    }
  }

  @override
  String toString() => 'CriterionQuestion(criterion: $criterion)';

  @override
  List<Object?> get props => [criterion];

  String get criterionName => criterion.name;
}
