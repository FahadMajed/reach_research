import 'package:reach_core/core/core.dart';

import 'benefit.dart';

enum EnrollmentStatus { enrolled, rejected, finished }

class Enrollment extends Equatable {
  final Participant participant;
  final String? researchId;
  final EnrollmentStatus status;
  final List<Benefit> benefits;
  final String groupId;
  final bool redeemed;

  String get partId => participant.participantId;
  String get name => participant.name;
  String get imageUrl => participant.imageUrl;
  int get color => participant.defaultColor;

  String get id => participant.participantId + (researchId ?? "");

  const Enrollment({
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

  Enrollment addBenefit(Benefit benefit) {
    return copyWith(
        benefits: benefits.isEmpty
            ? [benefit]
            : [
                ...benefits
                  ..removeWhere((b) => b.benefitName == benefit.benefitName),
                benefit
              ]);
  }

  Future<void> markAsSeen() async {}

  void insertUniqueBenefit(Benefit benefit) => benefits.add(benefit);

  toMap() {
    return {
      "participant": participant.toPartialMap(),
      'status': status.index,
      'groupId': groupId,
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
    String? researchId,
  }) {
    return Enrollment(
      participant: participant ?? this.participant,
      status: status ?? this.status,
      benefits: benefits ?? this.benefits,
      groupId: groupId ?? this.groupId,
      redeemed: redeemed ?? this.redeemed,
      researchId: researchId ?? this.researchId,
    );
  }

  factory Enrollment.empty() => Enrollment(
      benefits: const [],
      status: EnrollmentStatus.rejected,
      redeemed: false,
      groupId: '',
      participant: Participant.empty());

  factory Enrollment.init(
    Participant participant,
    String groupId,
  ) =>
      Enrollment(
          benefits: const [],
          status: EnrollmentStatus.enrolled,
          redeemed: false,
          groupId: groupId,
          participant: participant.partial);

  @override
  List<Object?> get props =>
      [benefits, redeemed, groupId, participant.participantId, status];
}
