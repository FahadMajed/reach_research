import 'package:reach_research/enrollments/domain/models/benefit.dart';

class BenefitsMapper {
  static Benefit _fromMap(data) {
    return Benefit(
        benefitName: data['benefitName'] ?? "",
        description: data['description'] ?? data['value'] ?? "",
        type: BenefitType.values[data['type'] ?? 0],
        benefitValue: data["benefitValue"] ?? "",
        place: data["place"] ?? "");
  }

  static Map<String, dynamic> _toMap(Benefit benefit) {
    return {
      'benefitName': benefit.benefitName,
      'description': benefit.description,
      'type': benefit.type.index,
      'benefitValue': benefit.benefitValue,
      "place": benefit.place
    };
  }

  static List<Benefit> fromMapList(Map<String, dynamic> data) =>
      (data['benefits'] as List).map(_fromMap).toList();

  static List<Map<String, dynamic>> toMapList(List<Benefit> elements) =>
      elements.map(_toMap).toList();
}
