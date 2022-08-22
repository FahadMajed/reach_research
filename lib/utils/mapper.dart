import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

Research researchFromMap(Map<String, dynamic> data) =>
    data["isGroupResearch"] ?? false
        ? GroupResearch(data)
        : SingularResearch(data);

Map<String, dynamic> researchToMap(Research research) =>
    research is SingularResearch
        ? research.toMap()
        : (research as GroupResearch).toMap();

Research copyResearchWith(Research toCopy,
    {List<Enrollment>? enrollments,
    Researcher? researcher,
    String? researchId,
    ResearchState? researchState,
    String? title,
    String? desc,
    String? category,
    Map<String, Criterion>? criteria,
    List<Question>? questions,
    List<Benefit>? benefits,
    int? sampleSize,
    int? numberOfMeetings,
    List? meetingsTimeSlots,
    List? meetingsDays,
    List? meetingsMethods,
    String? startDate,
    List<Meeting>? meetings,
    String? link,
    String? city,
    String? image,
    int? numberOfEnrolled,
    List<Phase>? phases,
    List? enrolledIds,
    List? rejectedIds,
    bool? isGroupResearch,
    int? numberOfGroups,
    int? groupSize,
    int? requestedParticipantsNumber,
    bool? isRequestingParticipants,
    int? requestJoiners,
    List<Group>? groups}) {
  final newData = {
    'enrollments': enrollments?.map((e) => e.toMap()).toList(),
    'researcher': researcher?.toMap(),
    'researchId': researchId,
    'researchState': researchState?.index,
    'requestJoiners': requestJoiners,
    'title': title,
    'desc': desc,
    'category': category,
    'criteria': criteria?.map(
      (key, criterion) => MapEntry(
        key,
        criterionToMap(criterion),
      ),
    ),
    'questions': questions?.map((e) => e.toMap()).toList(),
    'benefits': benefits?.map((e) => e.toMap()).toList(),
    'sampleSize': sampleSize,
    'numberOfMeetings': numberOfMeetings,
    'meetingsTimeSlots': meetingsTimeSlots,
    'meetingsDays': meetingsDays,
    'meetingsMethods': meetingsMethods,
    'startDate': startDate,
    'meetings': meetings?.map((e) => e.toMap()).toList(),
    'city': city,
    'image': image,
    'numberOfEnrolled': numberOfEnrolled,
    'phases': phases?.map((e) => e.toMap()).toList(),
    'isRequestingParticipants': isRequestingParticipants,
    'requestedParticipantsNumber': requestedParticipantsNumber,
    'enrolledIds': enrolledIds,
    'rejectedIds': rejectedIds,
    'isGroupResearch': isGroupResearch,
    'numberOfGroups': numberOfGroups,
    'groupSize': groupSize,
    'groups': groups?.map((e) => e.toMap()).toList(),
  };

  return toCopy is SingularResearch
      ? toCopy.copyWith(newData)
      : toCopy is GroupResearch
          ? toCopy.copyWith(newData)
          : toCopy.copyWith(newData);
}

Criterion criterionFromMap(Map<String, dynamic> data) {
  if (data["condition"] == null) {
    return RangeCriterion.fromMap(data);
  } else {
    return ValueCriterion.fromMap(data);
  }
}

Map<String, dynamic> criterionToMap(Criterion criterion) =>
    criterion is RangeCriterion
        ? criterion.toMap()
        : (criterion as ValueCriterion).toMap();


// import 'package:reach_core/core/core.dart';
// import 'package:reach_research/research.dart';

// Research researchFromMap(Map<String, dynamic> data) =>
//     data["isGroupResearch"] ?? false
//         ? GroupResearch(data)
//         : SingularResearch(data);

// Map<String, dynamic> researchToMap(Research research) =>
//     research is SingularResearch
//         ? research.toMap()
//         : (research as GroupResearch).toMap();

// Research copyResearchWith(Research toCopy,
//     {List<Enrollment>? enrollments,
//     Researcher? researcher,
//     String? researchId,
//     ResearchState? researchState,
//     String? title,
//     String? desc,
//     String? category,
//     Map<String, Criterion>? criteria,
//     List<Question>? questions,
//     List<Benefit>? benefits,
//     int? sampleSize,
//     int? numberOfMeetings,
//     List? meetingsTimeSlots,
//     List? meetingsDays,
//     List? meetingsMethods,
//     String? startDate,
//     List<Meeting>? meetings,
//     String? link,
//     String? city,
//     String? image,
//     int? numberOfEnrolled,
//     List<Phase>? phases,
//     List? enrolledIds,
//     List? rejectedIds,
//     bool? isGroupResearch,
//     int? numberOfGroups,
//     int? groupSize,
//     int? requestedParticipantsNumber,
//     bool? isRequestingParticipants,
//     int? requestJoiners,
//     List<Group>? groups}) {
//   final questionsToMap =
//       (questions ?? toCopy.questions).map((e) => e.toMap()).toList();
//   final meetingsToMap =
//       (meetings ?? toCopy.meetings).map((e) => e.toMap()).toList();
//   final benefitsToMap =
//       (benefits ?? toCopy.benefits).map((e) => e.toMap()).toList();
//   final criteriaToMap = {
//     for (final String criterion in criteria?.keys ?? [])
//       criterion: criterionToMap(criteria![criterion]!),
//   };
//   final phasesToMap = (phases ?? toCopy.phases).map((e) => e.toMap());
//   final researcherToMap = (researcher ?? toCopy.researcher).toMap();
//   return toCopy is SingularResearch
//       ? toCopy.copyWith({
//           'enrollments': (enrollments ?? toCopy.enrollments)
//               .map((e) => e.toMap())
//               .toList(),
//           'researcher': researcherToMap,
//           'researchId': researchId ?? toCopy.researchId,
//           'researchState': (researchState ?? toCopy.researchState).index,
//           'requestJoiners': requestJoiners ?? toCopy.requestJoiners,
//           'title': title ?? toCopy.title,
//           'desc': desc ?? toCopy.desc,
//           'category': category ?? toCopy.category,
//           'criteria': criteriaToMap,
//           'questions': questionsToMap,
//           'benefits': benefitsToMap,
//           'sampleSize': sampleSize ?? toCopy.sampleSize,
//           'numberOfMeetings': numberOfMeetings ?? toCopy.numberOfMeetings,
//           'meetingsTimeSlots': meetingsTimeSlots ?? toCopy.meetingsTimeSlots,
//           'meetingsDays': meetingsDays ?? toCopy.meetingsDays,
//           'meetingsMethods': meetingsMethods ?? toCopy.meetingsMethods,
//           'startDate': startDate ?? toCopy.startDate,
//           'meetings': meetingsToMap,
//           'city': city ?? toCopy.city,
//           'image': image ?? toCopy.image,
//           'numberOfEnrolled': numberOfEnrolled ?? toCopy.numberOfEnrolled,
//           'phases': phasesToMap,
//           'isRequestingParticipants':
//               isRequestingParticipants ?? toCopy.isRequestingParticipants,
//           'requestedParticipantsNumber':
//               requestedParticipantsNumber ?? toCopy.requestedParticipantsNumber,
//           'enrolledIds': enrolledIds ?? toCopy.enrolledIds,
//           'rejectedIds': rejectedIds ?? toCopy.rejectedIds,
//           'isGroupResearch': isGroupResearch ?? toCopy.isGroupResearch,
//         })
//       : toCopy is GroupResearch
//           ? toCopy.copyWith({
//               'numberOfGroups': numberOfGroups ?? (toCopy).numberOfGroups,
//               'groupSize': groupSize ?? (toCopy).groupSize,
//               'groups': (groups ?? (toCopy).groups).map((e) => e.toMap()),
//               'researcher': researcherToMap,
//               'researchId': researchId ?? toCopy.researchId,
//               'researchState': researchState ?? toCopy.researchState,
//               'title': title ?? toCopy.title,
//               'desc': desc ?? toCopy.desc,
//               'requestJoiners': requestJoiners ?? toCopy.requestJoiners,
//               'category': category ?? toCopy.category,
//               'criteria': criteriaToMap,
//               'questions': questionsToMap,
//               'benefits': benefitsToMap,
//               'sampleSize': sampleSize ?? toCopy.sampleSize,
//               'numberOfMeetings': numberOfMeetings ?? toCopy.numberOfMeetings,
//               'meetingsTimeSlots':
//                   meetingsTimeSlots ?? toCopy.meetingsTimeSlots,
//               'meetingsDays': meetingsDays ?? toCopy.meetingsDays,
//               'meetingsMethods': meetingsMethods ?? toCopy.meetingsMethods,
//               'startDate': startDate ?? toCopy.startDate,
//               'meetings': meetingsToMap,
//               'city': city ?? toCopy.city,
//               'isRequestingParticipants':
//                   isRequestingParticipants ?? toCopy.isRequestingParticipants,
//               'requestedParticipantsNumber': requestedParticipantsNumber ??
//                   toCopy.requestedParticipantsNumber,
//               'image': image ?? toCopy.image,
//               'numberOfEnrolled': numberOfEnrolled ?? toCopy.numberOfEnrolled,
//               'phases': phasesToMap,
//               'enrolledIds': enrolledIds ?? toCopy.enrolledIds,
//               'rejectedIds': rejectedIds ?? toCopy.rejectedIds,
//               'isGroupResearch': isGroupResearch ?? toCopy.isGroupResearch,
//             })
//           : toCopy.copyWith({
//               'title': title,
//               'desc': desc,
//               'category': category,
//               'criteria': criteriaToMap,
//               'questions': questionsToMap,
//               'benefits': benefitsToMap,
//               'sampleSize': sampleSize,
//               'numberOfMeetings': numberOfMeetings,
//               'meetingsTimeSlots': meetingsTimeSlots,
//               'meetingsDays': meetingsDays,
//               'meetingsMethods': meetingsMethods,
//               'startDate': startDate,
//               'city': city,
//               'image': image,
//               'isGroupResearch': isGroupResearch
//             });
// }

// Criterion criterionFromMap(Map<String, dynamic> data) {
//   if (data["condition"] == null) {
//     return RangeCriterion.fromMap(data);
//   } else {
//     return ValueCriterion.fromMap(data);
//   }
// }

// Map<String, dynamic> criterionToMap(Criterion criterion) =>
//     criterion is RangeCriterion
//         ? criterion.toMap()
//         : (criterion as ValueCriterion).toMap();


