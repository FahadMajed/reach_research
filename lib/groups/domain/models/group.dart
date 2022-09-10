import 'dart:convert';

import 'package:reach_core/core/core.dart';

import 'package:reach_research/research.dart';

class Group extends Equatable {
  final String researchId;

  final String groupName;
  final String groupId;
  final List<Enrollment> enrollments;

  List<String> get enrollmentsIds => enrollments.map((e) => e.partId).toList();
  const Group({
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
      'numberOfEnrolled': enrollments.length,
      'researchId': researchId,
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
  String toString() => toMap().toString();

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

  Group addBenefit(String enrollmentId, Benefit benefitToInsert) =>
      copyWith(enrollments: [
        for (final e in enrollments)
          if (e.id == enrollmentId) e.addBenefit(benefitToInsert) else e
      ]);

  void updateEnrollment(Participant participant, int index) {
    enrollments[index] = enrollments[index].copyWith(participant: participant);
  }

  bool isNotFull(int groupSize) => enrollments.length < groupSize;

  factory Group.empty() => const Group(
        groupName: '',
        enrollments: [],
        groupId: '',
        researchId: '',
      );

  @override
  List<Object?> get props => [groupName, enrollments, groupId, researchId];

  Group removeEnrollment(String participantId) => copyWith(
        enrollments: [
          for (final e in enrollments)
            if (e.partId != participantId) e
        ],
      );
}
