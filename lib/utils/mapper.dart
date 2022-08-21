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
        {List<EnrolledTo>? enrollments,
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
        List<Group>? groups}) =>
    toCopy is SingularResearch
        ? toCopy.copyWith({
            'enrollments': enrollments ?? toCopy.enrollments,
            'researcher': researcher ?? toCopy.researcher,
            'researchId': researchId ?? toCopy.researchId,
            'researchState': researchState ?? toCopy.researchState,
            'requestJoiners': requestJoiners ?? toCopy.requestJoiners,
            'title': title ?? toCopy.title,
            'desc': desc ?? toCopy.desc,
            'category': category ?? toCopy.category,
            'criteria': criteria ?? toCopy.criteria,
            'questions': questions ?? toCopy.questions,
            'benefits': benefits ?? toCopy.benefits,
            'sampleSize': sampleSize ?? toCopy.sampleSize,
            'numberOfMeetings': numberOfMeetings ?? toCopy.numberOfMeetings,
            'prefferedTimes': meetingsTimeSlots ?? toCopy.meetingsTimeSlots,
            'prefferedDays': meetingsDays ?? toCopy.meetingsDays,
            'prefferedMethods': meetingsMethods ?? toCopy.meetingsMethods,
            'startDate': startDate ?? toCopy.startDate,
            'meetings': meetings ?? toCopy.meetings,
            'city': city ?? toCopy.city,
            'image': image ?? toCopy.image,
            'numberOfEnrolled': numberOfEnrolled ?? toCopy.numberOfEnrolled,
            'phases': phases ?? toCopy.phases,
            'isRequestingParticipants':
                isRequestingParticipants ?? toCopy.isRequestingParticipants,
            'requestedParticipantsNumber': requestedParticipantsNumber ??
                toCopy.requestedParticipantsNumber,
            'enrolledIds': enrolledIds ?? toCopy.enrolledIds,
            'rejectedIds': rejectedIds ?? toCopy.rejectedIds,
            'isGroupResearch': isGroupResearch ?? toCopy.isGroupResearch,
          })
        : toCopy is GroupResearch
            ? toCopy.copyWith({
                'numberOfGroups': numberOfGroups ?? (toCopy).numberOfGroups,
                'groupSize': groupSize ?? (toCopy).groupSize,
                'groups': groups ?? (toCopy).groups,
                'researcher': researcher ?? toCopy.researcher,
                'researchId': researchId ?? toCopy.researchId,
                'researchState': researchState ?? toCopy.researchState,
                'title': title ?? toCopy.title,
                'desc': desc ?? toCopy.desc,
                'requestJoiners': requestJoiners ?? toCopy.requestJoiners,
                'category': category ?? toCopy.category,
                'criteria': criteria ?? toCopy.criteria,
                'questions': questions ?? toCopy.questions,
                'benefits': benefits ?? toCopy.benefits,
                'sampleSize': sampleSize ?? toCopy.sampleSize,
                'numberOfMeetings': numberOfMeetings ?? toCopy.numberOfMeetings,
                'meetingsTimeSlots':
                    meetingsTimeSlots ?? toCopy.meetingsTimeSlots,
                'prefferedDays': meetingsDays ?? toCopy.meetingsDays,
                'meetingsMethods': meetingsMethods ?? toCopy.meetingsMethods,
                'startDate': startDate ?? toCopy.startDate,
                'meetings': meetings ?? toCopy.meetings,
                'city': city ?? toCopy.city,
                'isRequestingParticipants':
                    isRequestingParticipants ?? toCopy.isRequestingParticipants,
                'requestedParticipantsNumber': requestedParticipantsNumber ??
                    toCopy.requestedParticipantsNumber,
                'image': image ?? toCopy.image,
                'numberOfEnrolled': numberOfEnrolled ?? toCopy.numberOfEnrolled,
                'phases': phases ?? toCopy.phases,
                'enrolledIds': enrolledIds ?? toCopy.enrolledIds,
                'rejectedIds': rejectedIds ?? toCopy.rejectedIds,
                'isGroupResearch': isGroupResearch ?? toCopy.isGroupResearch,
              })
            : toCopy.copyWith({
                'title': title,
                'desc': desc,
                'category': category,
                'criteria': criteria,
                'questions': questions,
                'benefits': benefits,
                'sampleSize': sampleSize,
                'numberOfMeetings': numberOfMeetings,
                'meetingsTimeSlots': meetingsTimeSlots,
                'meetingsDays': meetingsDays,
                'meetingsMethods': meetingsMethods,
                'startDate': startDate,
                'city': city,
                'image': image,
                'isGroupResearch': isGroupResearch
              });

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
