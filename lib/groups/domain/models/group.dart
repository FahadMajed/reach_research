import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class Group extends Equatable {
  final String researchId;

  final String groupId;
  final List<Enrollment> enrollments;
  final int groupNumber;

  int get numberOfEnrolled => enrollments.length;
  String get groupName => "Group $groupNumber";
  final List enrollmentsIds;

  const Group({
    required this.groupNumber,
    required this.enrollments,
    required this.groupId,
    required this.enrollmentsIds,
    required this.researchId,
  });

  Group copyWith({
    List<Enrollment>? enrollments,
    int? groupNumber,
    List? enrollmentsIds,
  }) {
    return Group(
        groupNumber: groupNumber ?? this.groupNumber,
        enrollments: enrollments ?? this.enrollments,
        groupId: groupId,
        researchId: researchId,
        enrollmentsIds: enrollmentsIds ?? this.enrollmentsIds);
  }

  int getParticipantIndex(String participantId) =>
      enrollments.indexWhere((element) => element.participant.participantId == participantId);

  Group addBenefit(String enrollmentId, Benefit benefitToInsert) => copyWith(enrollments: [
        for (final e in enrollments)
          if (e.id == enrollmentId) e.addBenefit(benefitToInsert) else e
      ]);

  Group updateParticipant(Participant participant) {
    return copyWith(
      enrollments: [
        for (final e in enrollments)
          if (e.partId == participant.participantId)
            e.copyWith(
              participant: participant,
            )
          else
            e
      ],
    );
  }

  Group updateEnrollment(Enrollment enrollment) {
    return copyWith(
      enrollments: [
        for (final e in enrollments)
          if (e.partId == enrollment.partId) enrollment else e
      ],
    );
  }

  Group removeEnrollment(String participantId) => copyWith(
        enrollments: [
          for (final e in enrollments)
            if (e.partId != participantId) e
        ],
        enrollmentsIds: enrollmentsIds..remove(participantId),
      );

  bool isNotFull(int groupSize) => enrollments.length < groupSize;

  factory Group.empty() => const Group(
        groupNumber: -1,
        enrollments: [],
        groupId: '',
        researchId: '',
        enrollmentsIds: [],
      );

  @override
  String toString() {
    return 'Group(researchId: $researchId, groupId: $groupId, enrollments: $enrollments, groupNumber: $groupNumber)';
  }

  Group addEnrollment(Enrollment enrollment) => copyWith(
        enrollments: enrollments..add(enrollment),
        enrollmentsIds: enrollmentsIds..add(enrollment.partId),
      );

  List<Participant> getParticipants() => enrollments.map((e) => e.participant).toList();

  bool hasParticipant(Participant participant) {
    return enrollmentsIds.contains(participant.participantId);
  }

  @override
  List<Object?> get props => [enrollments, groupNumber, groupId, researchId];

  Enrollment getEnrollment(String participantId) => enrollments.firstWhere((e) => e.partId == participantId);

  bool containEnrollment(Enrollment enrollment) {
    return hasParticipant(enrollment.participant);
  }

  Group markEnrollmentRedeemed(Enrollment enrollment) =>
      updateEnrollment(enrollment).removeEnrollmentId(enrollment.partId);

  Group removeEnrollmentId(String participatntId) => copyWith(enrollmentsIds: enrollmentsIds..remove(participatntId));
}
