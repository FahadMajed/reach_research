import 'package:reach_core/core/core.dart';
import 'package:reach_research/enrollments/enrollments.dart';
import 'package:reach_research/research/data/mappers/benefit_mapper.dart';
import 'package:reach_research/research/research.dart';

class EnrollmentsMapper {
  static Enrollment fromMap(data) {
    return Enrollment(
        researchId: data['researchId'],
        participant: ParticipantMapper.fromMap(data['participant']),
        status: EnrollmentStatus.values[data['status']],
        benefits: BenefitsMapper.fromMapList(data),
        redeemed: data['redeemed'] ?? false,
        groupId: data["groupId"] ?? "");
  }

  static Map<String, dynamic> toMap(Enrollment enrollment) {
    return {
      "participant": ParticipantMapper.toPartialMap(enrollment.participant),
      'status': enrollment.status.index,
      'groupId': enrollment.groupId,
      'redeemed': enrollment.redeemed,
      'benefits': BenefitsMapper.toMapList(enrollment.benefits),
      'researchId': enrollment.researchId,
    };
  }

  static List<Enrollment> fromMapList(Map<String, dynamic> data) =>
      (data["enrollments"] as List).map(fromMap).toList();

  static List<Map<String, dynamic>> toMapList(List<Enrollment> elements) =>
      elements.map(toMap).toList();
}
