import 'package:reach_research/enrollments/data/mappers/enrollments_mapper.dart';
import 'package:reach_research/groups/domain/models/group.dart';

class GroupsMapper {
  static Group fromMap(data) {
    return Group(
      enrollmentsIds: data["enrollmentsIds"] ?? [],
      groupNumber: data['groupNumber'] ?? int.tryParse(data['groupName'].toString().split(' ')[1]) ?? 0,
      groupId: data["groupId"] ?? "",
      enrollments: EnrollmentsMapper.fromMapList(data),
      researchId: data['researchId'],
    );
  }

  static Map<String, dynamic> toMap(Group group) {
    return {
      'groupNumber': group.groupNumber,
      'groupId': group.groupId,
      'enrollmentsIds': group.enrollmentsIds,
      'enrollments': EnrollmentsMapper.toMapList(group.enrollments),
      'numberOfEnrolled': group.enrollments.length,
      'researchId': group.researchId,
    };
  }

  static List<Group> fromMapList(Map<String, dynamic> data) => (data as List).map(fromMap).toList();

  static List<Map<String, dynamic>> toMapList(List<Group> elements) => elements.map(toMap).toList();
}
