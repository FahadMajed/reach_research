import 'package:reach_research/research/domain/domain.dart';

class PhasesMapper {
  static Phase _fromMap(data) {
    return Phase(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isChecked: data['isChecked'] ?? false,
        date: data['date']);
  }

  static Map<String, dynamic> _toMap(Phase phase) {
    return {
      'title': phase.title,
      'description': phase.description,
      "isChecked": phase.isChecked,
      'date': phase.date,
    };
  }

  static List<Phase> fromMapList(Map<String, dynamic> data) =>
      (data['phases'] as List).map(_fromMap).toList();

  static List<Map<String, dynamic>> toMapList(List<Phase> elements) =>
      elements.map(_toMap).toList();
}
