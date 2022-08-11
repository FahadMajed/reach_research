import 'package:reach_core/core/models/models.dart';

import 'benefit.dart';

enum EnrollmentStatus { Enrolled, Rejected, Finished }

class EnrolledTo {
  final Participant participant;

  final String status;
  final List<Benefit> benefits;
  final String groupId;
  final bool redeemed;

  EnrolledTo({
    required this.benefits,
    required this.status,
    required this.redeemed,
    required this.groupId,
    required this.participant,
  });

  factory EnrolledTo.fromFirestore(Map enrollmentData) {
    return EnrolledTo(
        participant:
            Participant.fromFirestore(enrollmentData["participant"] ?? {}),
        status: enrollmentData['status'] ?? 'rejected',
        benefits: (enrollmentData['benefits'] as List)
            .map((v) => Benefit.fromMap(v))
            .toList(),
        redeemed: enrollmentData['redeemed'] ?? false,
        groupId: enrollmentData["groupId"] ?? "");
  }

  Future<void> markAsSeen() async {}

  void insertUniqueBenefit(Benefit benefit) => benefits.add(benefit);

  toMap() {
    return {
      "participant": participant.toPartialMap(),
      'status': status,
      'redeemed': redeemed,
      'benefits': benefits.map((x) => x.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'EnrolledTo(${participant.toPartialMap()} , status: $status, redeemed: $redeemed, )';
  }
}
