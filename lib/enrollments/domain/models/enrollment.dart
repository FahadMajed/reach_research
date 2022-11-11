import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum EnrollmentStatus { enrolled, rejected, finished, notDetermined }

class Enrollment extends Equatable {
  final Participant participant;
  final Research? research;
  final String researchId;
  //researchId is from data, wheras research will
  //be set in run time by state management
  final EnrollmentStatus status;
  final List<Benefit> benefits;
  final String groupId;
  final bool redeemed;
  final Meeting? upcomingMeeting;

  String get partId => participant.participantId;

  String get name => participant.name;
  String get imageUrl => participant.imageUrl;
  int get color => participant.defaultColor;

  String get id => participant.participantId + (researchId);

  const Enrollment({
    this.research,
    this.researchId = "",
    required this.benefits,
    required this.status,
    required this.redeemed,
    required this.groupId,
    required this.participant,
    this.upcomingMeeting,
  });

  factory Enrollment.create(
    Participant participant, {
    String? groupId,
    Research? research,
    String? researchId,
  }) =>
      Enrollment(
        participant: participant,
        status: EnrollmentStatus.enrolled,
        redeemed: false,
        groupId: groupId ?? "",
        benefits: const [],
        research: research,
        researchId: researchId ?? research?.researchId ?? "",
      );

  Enrollment addBenefit(Benefit benefit) {
    return copyWith(
        benefits: benefits.isEmpty
            ? [benefit]
            : [...benefits..removeWhere((b) => b.benefitName == benefit.benefitName), benefit]);
  }

  Enrollment copyWith({
    Participant? participant,
    EnrollmentStatus? status,
    List<Benefit>? benefits,
    String? groupId,
    bool? redeemed,
    Research? research,
    String? researchId,
    Meeting? upcomingMeeting,
  }) {
    return Enrollment(
        participant: participant ?? this.participant,
        status: status ?? this.status,
        benefits: benefits ?? this.benefits,
        groupId: groupId ?? this.groupId,
        redeemed: redeemed ?? this.redeemed,
        research: research ?? this.research,
        researchId: researchId ?? research?.researchId ?? this.researchId,
        upcomingMeeting: upcomingMeeting ?? this.upcomingMeeting);
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
          participant: participant);

  @override
  List<Object?> get props => [
        participant,
        benefits,
        redeemed,
        status,
      ];

  @override
  String toString() {
    return 'Enrollment(participant: $participant,  researchId: $researchId, status: $status, benefits: $benefits, groupId: $groupId, redeemed: $redeemed)';
  }

  bool benefitsAreNotCompleted(int numberOfBenefits) {
    if (benefits.length != numberOfBenefits) {
      return true;
    }
    for (final benefit in benefits) {
      if (benefit.benefitValue.isEmpty) return true;
    }
    return false;
  }

  Enrollment markRedeemed() => copyWith(
        redeemed: true,
        status: EnrollmentStatus.finished,
      );
}
