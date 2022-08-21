import 'dart:convert';

import 'package:reach_core/core/models/participant.dart';
import 'package:reach_research/models/benefit.dart';

import 'enroled_to.dart';

class Group {
  final String groupName;
  final String groupId;
  final List<EnrolledTo> enrollments;

  Group({
    required this.groupName,
    required this.enrollments,
    required this.groupId,
  });

  toMap() {
    return {
      'groupName': groupName,
      'groupId': groupId,
      'enrollments': enrollments.map((x) => x.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> groupData) {
    return Group(
      groupName: groupData['groupName'] ?? '',
      groupId: groupData["groupId"] ?? "",
      enrollments: (groupData["participants"] as List)
          .map((v) => EnrolledTo.fromMap(v))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'Group(groupName: $groupName, groupId: $groupId,} })})';

  Group copyWith(String groupName) {
    return Group(
        groupName: groupName, enrollments: enrollments, groupId: groupId);
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
}
