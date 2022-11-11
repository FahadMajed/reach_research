import 'package:reach_research/research/research.dart';

class QuestionsMapper {
  static CustomizedQuestion _fromMap(data) {
    return CustomizedQuestion(
        expectedAnswer: data['expectedAnswer'] ?? false,
        questionText: data['question']);
  }

  static Map<String, dynamic> _toMap(CustomizedQuestion question) {
    return {
      'question': question.questionText,
      'expectedAnswer': question.expectedAnswer,
    };
  }

  static List<CustomizedQuestion> fromMapList(Map<String, dynamic> data) =>
      (data['questions'] as List).map(_fromMap).toList();

  static List<Map<String, dynamic>> toMapList(
          List<CustomizedQuestion> elements) =>
      elements.map(_toMap).toList();
}
