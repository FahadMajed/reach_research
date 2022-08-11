import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupResearch extends Research {
  final int numberOfGroups;
  final int groupSize;
  final List<Group> groups;

  GroupResearch(
      {required this.numberOfGroups,
      required this.groupSize,
      this.groups = const [],
      researchId,
      required ResearchState state,
      title = "",
      desc = "",
      required image,
      required questions,
      required numberOfEnrolled,
      required sampleSize,
      benefits = const [],
      List<Meeting> meetings = const [],
      required numberOfMeetings,
      preferredDays = const [],
      preferredTimes = const [],
      preferredMethods = const [],
      enrolledIds = const [],
      requestJoiners = 0,
      isGroupResearch = true,
      city = "",
      required criteria,
      List<Phase> phases = const [],
      required researcher,
      category = '',
      rejectedIds = const [],
      isRequestingParticipants = false,
      requestedParticipantsNumber = 0,
      required startDate})
      : super(
            researchId: researchId,
            state: state,
            title: title,
            desc: desc,
            image: image,
            questions: questions,
            numberOfEnrolled: numberOfEnrolled,
            sampleSize: sampleSize,
            benefits: benefits,
            meetings: meetings,
            numberOfMeetings: numberOfMeetings,
            preferredDays: preferredDays,
            preferredTimes: preferredTimes,
            preferredMethods: preferredMethods,
            enrolledIds: enrolledIds,
            city: city,
            isGroupResearch: isGroupResearch,
            criteria: criteria,
            phases: phases,
            researcher: researcher,
            category: category,
            requestedParticipantsNumber: requestedParticipantsNumber,
            rejectedIds: rejectedIds,
            requestJoiners: requestJoiners,
            isRequestingParticipants: isRequestingParticipants,
            startDate: startDate);

  @override
  toMap() {
    var data = super.toMap();

    data['numberOfGroups'] = numberOfGroups;
    data['groupSize'] = groupSize;
    data['groups'] = groups.map((g) => g.toMap()).toList();

    return data;
  }

  @override
  toPartialMap() {
    var data = super.toPartialMap();

    data['numberOfGroups'] = numberOfGroups;
    data['groupSize'] = groupSize;
    data['groups'] = groups.map((g) => g.toMap()).toList();

    return data;
  }

  factory GroupResearch.fromFirestore(Map<String, dynamic> researchData) {
    Map<String, Criterion> criteria = {};

    for (String key in researchData['criteria'].keys) {
      criteria[key] = criterionFromMap(researchData['criteria'][key]);
    }

    return GroupResearch(
      numberOfGroups: researchData['numberOfGroups'] ?? 0,
      groupSize: researchData['groupSize'] ?? 0,
      isGroupResearch: true,
      groups: (researchData['groups'] as List)
          .map((v) => Group.fromFirestore(v))
          .toList(),
      researchId: researchData['researchId'] ?? '',
      researcher: Researcher.fromFirestore(researchData["researcher"] ?? {}),
      state: ResearchState.values[researchData['state'] ?? 0],
      title: researchData["title"] ?? '',
      desc: researchData["desc"] ?? '',
      category: researchData['category'] ?? '',
      criteria: criteria,
      questions: (researchData['questions'] as List)
          .map((v) => Question.fromFirestore(v))
          .toList(),
      benefits: (researchData['benefits'] as List)
          .map((v) => Benefit.fromMap(v))
          .toList(),
      meetings: (researchData['meetings'] as List)
          .map((v) => Meeting.fromFirestore(v))
          .toList(),
      city: researchData['city'] ?? '',
      numberOfMeetings: researchData['numberOfMeetings'] ?? 0,
      preferredDays: researchData['prefferedDays'] ?? [],
      preferredTimes: researchData['prefferedTimes'] ?? [],
      preferredMethods: researchData['prefferedMethods'] ?? [],
      startDate: researchData["startDate"] ?? "2021-10-10",
      image: researchData['image'] ?? 'f&b4.jpg',
      sampleSize: researchData["sampleSize"] ?? 1,
      numberOfEnrolled: researchData['numberOfEnrolled'] ?? 0,
      phases: (researchData['phases'] as List)
          .map((v) => Phase.fromFirestore(v))
          .toList(),
      enrolledIds: (researchData["enrolledIds"] as List),
      rejectedIds: (researchData["rejectedIds"] as List),
      isRequestingParticipants:
          researchData["isRequestingParticipants"] ?? false,
      requestedParticipantsNumber:
          researchData["requestedParticipantsNumber"] ?? 0,
      requestJoiners: researchData["requestJoiners"] ?? 0,
    );
  }

  factory GroupResearch.copy(
          Research research, int numberOfGroups, int groupSize) =>
      GroupResearch(
        sampleSize: groupSize * numberOfGroups,
        numberOfGroups: numberOfGroups,
        groupSize: groupSize,
        groups: [],
        researcher: research.researcher,
        researchId: "",
        state: research.state,
        title: research.title,
        desc: research.desc,
        category: research.category,
        criteria: research.criteria,
        questions: research.questions,
        benefits: research.benefits,
        numberOfMeetings: research.numberOfMeetings,
        preferredTimes: research.preferredTimes,
        preferredDays: research.preferredDays,
        preferredMethods: research.preferredMethods,
        startDate: research.startDate,
        meetings: research.meetings,
        city: research.city,
        image: research.image,
        numberOfEnrolled: research.numberOfEnrolled,
        phases: research.phases,
        enrolledIds: research.enrolledIds,
        rejectedIds: research.rejectedIds,
        isGroupResearch: true,
      );

  bool changeParticipantGroup(
      int participantIndex, int prevGroupIndex, int newGroupIndex) {
    EnrolledTo participantToChange =
        groups[prevGroupIndex].participants[participantIndex];
    groups[prevGroupIndex].participants.remove(participantToChange);
    groups[newGroupIndex].participants.add(participantToChange);

    return true;
  }

  void addUniqueBenefit(EnrolledTo enrollment, Benefit benefit) =>
      groups.forEach((group) {
        bool alreadyInserted = false;

        for (var b in enrollment.benefits) {
          b.benefitName == benefit.benefitName ? alreadyInserted = true : null;
        }
        int currentEnrollmentIndex = group.participants.indexWhere((e) =>
            e.participant.participantId ==
            enrollment.participant.participantId);
        if (currentEnrollmentIndex != -1) {
          if (alreadyInserted) {
            group.participants[currentEnrollmentIndex].benefits
                .removeWhere((b) => b.benefitName == benefit.benefitName);
          }

          group.participants[currentEnrollmentIndex].benefits.add(benefit);
        }
      });

  void addUnifiedBenefit(Benefit benefit) => groups.forEach(
        (group) => group.participants.forEach(
          (enrollment) {
            bool alreadyInserted = false;
            for (var b in enrollment.benefits) {
              if (b.benefitName == benefit.benefitName) {
                alreadyInserted = true;
              }
            }
            if (alreadyInserted) {
              enrollment.benefits
                  .removeWhere((b) => b.benefitName == benefit.benefitName);
            }

            enrollment.benefits.add(benefit);
          },
        ),
      );

  GroupResearch copyWith2(
      {int? numberOfGroups,
      int? groupSize,
      List<Group>? groups,
      Researcher? researcher,
      String? researchId,
      ResearchState? state,
      String? title,
      String? desc,
      String? category,
      String? languageCode,
      Map<String, Criterion>? criteria,
      List<Question>? questions,
      List<Benefit>? benefits,
      int? sampleSize,
      int? numberOfMeetings,
      List? prefferedTimes,
      List? prefferedDays,
      List? prefferedMethods,
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
      int? requestJoiners,
      bool? isRequestingParticipants,
      int? requestedParticipantsNumber}) {
    return GroupResearch(
        numberOfGroups: numberOfGroups ?? this.numberOfGroups,
        groupSize: groupSize ?? this.groupSize,
        groups: groups ?? this.groups,
        researcher: researcher ?? this.researcher,
        researchId: researchId ?? this.researchId,
        state: state ?? this.state,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        category: category ?? this.category,
        criteria: criteria ?? this.criteria,
        questions: questions ?? this.questions,
        benefits: benefits ?? this.benefits,
        sampleSize: sampleSize ?? this.sampleSize,
        numberOfMeetings: numberOfMeetings ?? this.numberOfMeetings,
        preferredTimes: prefferedTimes ?? preferredTimes,
        preferredDays: prefferedDays ?? preferredDays,
        preferredMethods: prefferedMethods ?? preferredMethods,
        startDate: startDate ?? this.startDate,
        meetings: meetings ?? this.meetings,
        requestJoiners: requestJoiners ?? this.requestJoiners,
        city: city ?? this.city,
        image: image ?? this.image,
        numberOfEnrolled: numberOfEnrolled ?? this.numberOfEnrolled,
        phases: phases ?? this.phases,
        enrolledIds: enrolledIds ?? this.enrolledIds,
        rejectedIds: rejectedIds ?? this.rejectedIds,
        isGroupResearch: isGroupResearch ?? this.isGroupResearch,
        requestedParticipantsNumber:
            requestedParticipantsNumber ?? this.requestedParticipantsNumber,
        isRequestingParticipants:
            isRequestingParticipants ?? this.isRequestingParticipants);
  }

  String getFirstNonFullGroupId() => "";
}
