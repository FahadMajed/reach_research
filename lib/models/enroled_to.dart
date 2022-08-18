import 'package:flutter/foundation.dart';
import 'package:reach_core/core/models/models.dart';

import 'benefit.dart';

enum EnrollmentStatus { enrolled, rejected, finished }

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
        participant: Participant(enrollmentData["participant"] ?? {}),
        status: enrollmentData['status'] ?? 'rejected',
        benefits: (enrollmentData['benefits'] as List)
            .map((v) => Benefit.fromMap(v))
            .toList(),
        redeemed: enrollmentData['redeemed'] ?? false,
        groupId: enrollmentData["groupId"] ?? "");
  }

  void removeBenefit(String benefitName) =>
      benefits.removeWhere((b) => b.benefitName == benefitName);

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
    return 'EnrolledTo(participant: $participant, status: $status, benefits: $benefits, groupId: $groupId, redeemed: $redeemed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnrolledTo &&
        other.participant == participant &&
        other.status == status &&
        listEquals(other.benefits, benefits) &&
        other.groupId == groupId &&
        other.redeemed == redeemed;
  }

  @override
  int get hashCode {
    return participant.hashCode ^
        status.hashCode ^
        benefits.hashCode ^
        groupId.hashCode ^
        redeemed.hashCode;
  }
}
