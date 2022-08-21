import 'package:reach_core/core/models/models.dart';

import 'benefit.dart';

enum EnrollmentStatus { enrolled, rejected, finished }

class EnrolledTo {
  final Participant participant;

  final EnrollmentStatus status;
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

  factory EnrolledTo.fromMap(Map enrollmentData) {
    return EnrolledTo(
        participant: Participant(enrollmentData["participant"] ?? {}),
        status: EnrollmentStatus.values[enrollmentData['status']],
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
  String toString() => toMap().toString();

  EnrolledTo copyWith({
    Participant? participant,
    EnrollmentStatus? status,
    List<Benefit>? benefits,
    String? groupId,
    bool? redeemed,
  }) {
    return EnrolledTo(
      participant: participant ?? this.participant,
      status: status ?? this.status,
      benefits: benefits ?? this.benefits,
      groupId: groupId ?? this.groupId,
      redeemed: redeemed ?? this.redeemed,
    );
  }
}
