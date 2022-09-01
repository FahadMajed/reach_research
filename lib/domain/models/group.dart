import 'dart:convert';

import 'package:reach_core/core/domain/domain.dart';

import 'models.dart';

class Group {
  final String researchId;

  final String groupName;
  final String groupId;
  final List<Enrollment> enrollments;

  int get numberOfEnrolled => enrollments.length;

  Group({
    required this.groupName,
    required this.enrollments,
    required this.groupId,
    required this.researchId,
  });

  toMap() {
    return {
      'groupName': groupName,
      'groupId': groupId,
      'enrollments': enrollments.map((x) => x.toMap()).toList(),
      'researchId': researchId,
      'numberOfEnrolled': numberOfEnrolled,
    };
  }

  factory Group.fromMap(Map<String, dynamic> groupData) {
    return Group(
      groupName: groupData['groupName'] ?? '',
      groupId: groupData["groupId"] ?? "",
      enrollments: (groupData["enrollments"] as List)
          .map((v) => Enrollment.fromMap(v))
          .toList(),
      researchId: groupData['researchId'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Group(groupName: $groupName, groupId: $groupId,} })})';

  Group copyWith({
    String? groupName,
    List<Enrollment>? enrollments,
  }) {
    return Group(
      groupName: groupName ?? this.groupName,
      enrollments: enrollments ?? this.enrollments,
      groupId: groupId,
      researchId: researchId,
    );
  }

  int getParticipantIndex(String participantId) => enrollments.indexWhere(
      (element) => element.participant.participantId == participantId);

  void removeBenefit(int partIndex, String benefitName) =>
      enrollments[partIndex].removeBenefit(benefitName);

  void addBenefit(int partIndex, Benefit benefitToInsert) =>
      enrollments[partIndex].benefits.add(benefitToInsert);

  void updateEnrollment(Participant participant, int index) {
    enrollments[index] = enrollments[index].copyWith(participant: participant);
  }

  bool isNotFull(int groupSize) => enrollments.length < groupSize;

  factory Group.empty() => Group(
        groupName: '',
        enrollments: [],
        groupId: '',
        researchId: '',
      );
}
