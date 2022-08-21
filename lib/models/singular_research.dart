import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class SingularResearch extends Research {
  SingularResearch(Map<String, dynamic> jSON) : super(jSON);

  List<EnrolledTo> get enrollments =>
      (data['enrollments'] as List).map((e) => EnrolledTo.fromMap(e)).toList();

  void addUniqueBenefit(EnrolledTo enrollment, Benefit benefitToInsert) {
    bool alreadyInserted = false;

    for (final benefit in enrollment.benefits) {
      if (benefit.benefitName == benefitToInsert.benefitName) {
        alreadyInserted = true;
      }
    }
    int partIndex = getParticipantIndex(
      enrollment.participant.participantId,
    );
    if (alreadyInserted) {
      removeBenefit(
        partIndex,
        benefitToInsert.benefitName,
      );
    }

    enrollments[partIndex].benefits.add(benefitToInsert);
  }

  List<Participant> getParticipants() =>
      [for (final e in enrollments) e.participant];

  int getParticipantIndex(String participantId) => enrollments
      .indexWhere((e) => e.participant.participantId == participantId);

  void removeBenefit(int index, String benefitName) => enrollments[index]
      .benefits
      .removeWhere((b) => b.benefitName == benefitName);

  @override
  toMap() {
    final data = super.toMap();
    data["enrollments"] = enrollments.map((x) => x.toMap()).toList();
    return data;
  }

  @override
  toPartialMap() {
    final data = super.toPartialMap();
    data["enrollments"] = enrollments.map((x) => x.toMap()).toList();
    return data;
  }

  @override
  SingularResearch copyWith(Map<String, dynamic> newData) => SingularResearch({
        ...data,
        ...newData
          ..removeWhere(
            (key, value) => value == null,
          ),
      });

  @override
  factory SingularResearch.copy(Research research) => SingularResearch({
        ...research.toMap(),
        'enrollments': [],
        'isGroupResearch': false,
      });

  @override
  String toString() => toMap().toString();

  void updateParticipant(Participant participant) {
    final index = getParticipantIndex(participant.participantId);
    enrollments[index] = enrollments[index].copyWith(participant: participant);
  }
}
