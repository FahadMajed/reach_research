import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupResearch extends Research {
  final int numberOfGroups;
  final int groupSize;
  final List<Group> groups;

  GroupResearch({
    required this.numberOfGroups,
    required this.groupSize,
    this.groups = const [],
    required String researchId,
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
    required startDate,
  }) : super(
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

  void addUniqueBenefit(EnrolledTo enrollment, Benefit benefitToInsert) {
    for (final group in groups) {
      bool alreadyInserted = false;

      for (var benefit in enrollment.benefits) {
        benefit.benefitName == benefitToInsert.benefitName
            ? alreadyInserted = true
            : null;
      }
      int partIndex =
          group.getParticipantIndex(enrollment.participant.participantId);

      if (partIndex != -1) {
        if (alreadyInserted) {
          group.removeBenefit(partIndex, benefitToInsert.benefitName);
        }

        group.addBenefit(partIndex, benefitToInsert);
      }
    }
  }

  List<EnrolledTo> getAllEnrollments() => [
        for (final g in groups)
          for (final enrollment in g.participants) enrollment
      ];

  List<Participant> getAllParticipants() => [
        for (final g in groups)
          for (final enrollment in g.participants) enrollment.participant
      ];

  List<Participant> getAllParticipantsAt(int groupIndex) => [
        for (final enrollment in groups[groupIndex].participants)
          enrollment.participant
      ];

  void addUnifiedBenefit(Benefit benefitToInsert) {
    for (final enrollment in getAllEnrollments()) {
      bool alreadyInserted = false;
      for (final benefit in enrollment.benefits) {
        if (benefit.benefitName == benefitToInsert.benefitName) {
          alreadyInserted = true;
        }
      }

      if (alreadyInserted) {
        enrollment.removeBenefit(benefitToInsert.benefitName);
      }

      enrollment.benefits.add(benefitToInsert);
    }
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupResearch &&
        other.researcher == researcher &&
        other.researchId == researchId &&
        other.state == state &&
        other.title == title &&
        other.desc == desc &&
        other.category == category &&
        mapEquals(other.criteria, criteria) &&
        listEquals(other.questions, questions) &&
        listEquals(other.benefits, benefits) &&
        other.sampleSize == sampleSize &&
        other.numberOfMeetings == numberOfMeetings &&
        listEquals(other.preferredTimes, preferredTimes) &&
        listEquals(other.preferredDays, preferredDays) &&
        listEquals(other.preferredMethods, preferredMethods) &&
        other.startDate == startDate &&
        listEquals(other.meetings, meetings) &&
        other.city == city &&
        other.image == image &&
        other.numberOfEnrolled == numberOfEnrolled &&
        listEquals(other.phases, phases) &&
        listEquals(other.enrolledIds, enrolledIds) &&
        listEquals(other.rejectedIds, rejectedIds) &&
        other.isGroupResearch == isGroupResearch &&
        other.isRequestingParticipants == isRequestingParticipants &&
        other.requestedParticipantsNumber == requestedParticipantsNumber &&
        other.requestJoiners == requestJoiners &&
        other.numberOfGroups == numberOfGroups &&
        other.groupSize == groupSize &&
        listEquals(other.groups, groups);
  }

  @override
  int get hashCode =>
      numberOfGroups.hashCode ^
      groupSize.hashCode ^
      groups.hashCode ^
      researcher.hashCode ^
      researchId.hashCode ^
      state.hashCode ^
      title.hashCode ^
      desc.hashCode ^
      category.hashCode ^
      criteria.hashCode ^
      questions.hashCode ^
      benefits.hashCode ^
      sampleSize.hashCode ^
      numberOfMeetings.hashCode ^
      preferredTimes.hashCode ^
      preferredDays.hashCode ^
      preferredMethods.hashCode ^
      startDate.hashCode ^
      meetings.hashCode ^
      city.hashCode ^
      image.hashCode ^
      numberOfEnrolled.hashCode ^
      phases.hashCode ^
      enrolledIds.hashCode ^
      rejectedIds.hashCode ^
      isGroupResearch.hashCode ^
      isRequestingParticipants.hashCode ^
      requestedParticipantsNumber.hashCode ^
      requestJoiners.hashCode;

  @override
  String toString() =>
      '${super.toString()} GroupResearch(numberOfGroups: $numberOfGroups, groupSize: $groupSize, groups: $groups)';
}
