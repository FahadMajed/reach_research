import 'package:reach_core/core/domain/domain.dart';

import 'benefit.dart';

enum EnrollmentStatus { enrolled, rejected, finished }

class Enrollment {
  final Participant participant;
  final String? researchId;
  final EnrollmentStatus status;
  final List<Benefit> benefits;
  final String groupId;
  final bool redeemed;

  String get partId => participant.participantId;
  String get id => participant.participantId + (researchId ?? "");

  Enrollment({
    this.researchId = "",
    required this.benefits,
    required this.status,
    required this.redeemed,
    required this.groupId,
    required this.participant,
  });

  factory Enrollment.fromMap(Map enrollmentData) {
    return Enrollment(
        researchId: enrollmentData['researchId'],
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
      'status': status.index,
      'redeemed': redeemed,
      'benefits': benefits.map((x) => x.toMap()).toList(),
      'researchId': researchId,
    };
  }

  @override
  String toString() => toMap().toString();

  Enrollment copyWith({
    Participant? participant,
    EnrollmentStatus? status,
    List<Benefit>? benefits,
    String? groupId,
    bool? redeemed,
  }) {
    return Enrollment(
      participant: participant ?? this.participant,
      status: status ?? this.status,
      benefits: benefits ?? this.benefits,
      groupId: groupId ?? this.groupId,
      redeemed: redeemed ?? this.redeemed,
      researchId: researchId,
    );
  }

  factory Enrollment.empty() => Enrollment(
      benefits: [],
      status: EnrollmentStatus.rejected,
      redeemed: false,
      groupId: '',
      participant: Participant.empty());
}
