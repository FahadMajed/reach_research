
// class Enrollments {
//   final List<Enrollment> enrollments;

//   Enrollments(this.enrollments);

//   /////////////////////////////////

//   void addUniqueBenefit(Enrollment enrollment, Benefit benefitToInsert) {
//     bool isAlreadyInserted = false;

//     for (final benefit in enrollment.benefits) {
//       if (benefit.benefitName == benefitToInsert.benefitName) {
//         isAlreadyInserted = true;
//       }
//     }
//     int partIndex = _getParticipantIndex(
//       enrollment.participant.participantId,
//     );
//     if (isAlreadyInserted) {
//       _removeBenefit(
//         partIndex,
//         benefitToInsert.benefitName,
//       );
//     }

//     enrollments[partIndex].benefits.add(benefitToInsert);
//   }

//   List<Participant> getParticipants() =>
//       [for (final e in enrollments) e.participant];

//   int _getParticipantIndex(String participantId) => enrollments
//       .indexWhere((e) => e.participant.participantId == participantId);

//   void _removeBenefit(int index, String benefitName) => enrollments[index]
//       .benefits
//       .removeWhere((b) => b.benefitName == benefitName);

//   void updateParticipant(Participant participant) {
//     final index = _getParticipantIndex(participant.participantId);
//     enrollments[index] = enrollments[index].copyWith(participant: participant);
//   }
// }
