import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum ResearchState { Upcoming, Ongoing, Redeeming, Done }

class Research {
  final Researcher researcher;

  final String researchId;
  final ResearchState state;

  final String title;
  final String desc;
  final String category;

  final Map<String, Criterion> criteria;
  final List<Question> questions;

  final List<Benefit> benefits;

  final int sampleSize;

  final int numberOfMeetings;

  final List preferredTimes;
  final List preferredDays;
  final List preferredMethods;

  final String startDate;

  final List<Meeting> meetings;

  final String city;

  final String image;

  final int numberOfEnrolled;

  final List<Phase> phases;

  final List enrolledIds;
  final List rejectedIds;

  final bool isGroupResearch;

  final bool isRequestingParticipants;
  final int requestedParticipantsNumber;
  final int requestJoiners;

  Research({
    this.researchId = "",
    this.state = ResearchState.Upcoming,
    this.title = "",
    this.desc = "",
    this.image = "",
    this.questions = const [],
    this.numberOfEnrolled = 0,
    this.sampleSize = 0,
    this.benefits = const [],
    this.meetings = const [],
    this.numberOfMeetings = 0,
    this.preferredDays = const [],
    this.preferredTimes = const [],
    this.preferredMethods = const [],
    this.enrolledIds = const [],
    this.city = "",
    this.criteria = const {},
    this.isGroupResearch = false,
    this.phases = const [],
    required this.researcher,
    this.category = '',
    this.rejectedIds = const [],
    this.startDate = "2022-08-08",
    this.isRequestingParticipants = false,
    this.requestedParticipantsNumber = 0,
    this.requestJoiners = 0,
  });

  bool get isNotFull => sampleSize != numberOfEnrolled;

  void rejectParticipant(String participantId) async =>
      rejectedIds.add(participantId);

  void removeParticipant(String participantId) {
    enrolledIds.remove(participantId);
  }

//for duplication
  toPartialMap() => {
        "isGroupResearch": isGroupResearch,
        'researchId': researchId,
        'state': state.index,
        'title': title,
        'benefits': benefits.map((x) => x.toMap()).toList(),
        'meetings': meetings.map((x) => x.toMap()).toList(),
        'sampleSize': sampleSize,
        'numberOfEnrolled': numberOfEnrolled,
        'phases': phases.map((x) => x.toMap()).toList(),
        'researcher': researcher.toPartialMap(),
        "startDate": startDate,
        'enrolledIds': enrolledIds,
      };

//for master doc
  toMap() => {
        'researchId': researchId,
        "isGroupResearch": isGroupResearch,
        'state': state.index,
        'title': title,
        'desc': desc,
        'category': category,
        'criteria': criteria
            .map((name, criteria) => MapEntry(name, criterionToMap(criteria))),
        'questions': questions.map((x) => x.toMap()).toList(),
        'benefits': benefits.map((x) => x.toMap()).toList(),
        'city': city,
        'meetings': meetings.map((x) => x.toMap()).toList(),
        'image': image,
        "startDate": startDate,
        "numberOfMeetings": numberOfMeetings,
        "prefferedDays": preferredDays,
        "prefferedTimes": preferredTimes,
        "prefferedMethods": preferredMethods,
        'sampleSize': sampleSize,
        'numberOfEnrolled': numberOfEnrolled,
        'phases': phases.map((x) => x.toMap()).toList(),
        'enrolledIds': enrolledIds,
        "rejectedIds": rejectedIds,
        'researcher': researcher.toPartialMap(),
        'isRequestingParticipants': isRequestingParticipants,
        "requestedParticipantsNumber": requestedParticipantsNumber,
        "requestJoiners": requestJoiners,
      };

  bool scheduleIsNotEmpty() =>
      preferredDays.isNotEmpty &&
      preferredTimes.isNotEmpty &&
      preferredMethods.isNotEmpty &&
      startDate != DateTime.now().toString().substring(0, 10);

  bool enrolledIdsContains(String participantId) =>
      enrolledIds.contains(participantId);

  Research copyWith({
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
    List? preferredTimes,
    List? preferredDays,
    List? preferredMethods,
    String? startDate,
    List<Meeting>? meetings,
    String? city,
    String? image,
    int? numberOfEnrolled,
    List<Phase>? phases,
    List? enrolledIds,
    List? rejectedIds,
    bool? isGroupResearch,
    bool? isRequestingParticipants,
    int? requestedParticipantsNumber,
    int? requestJoiners,
  }) {
    return Research(
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
      preferredTimes: preferredTimes ?? this.preferredTimes,
      preferredDays: preferredDays ?? this.preferredDays,
      preferredMethods: preferredMethods ?? this.preferredMethods,
      startDate: startDate ?? this.startDate,
      meetings: meetings ?? this.meetings,
      city: city ?? this.city,
      image: image ?? this.image,
      numberOfEnrolled: numberOfEnrolled ?? this.numberOfEnrolled,
      phases: phases ?? this.phases,
      enrolledIds: enrolledIds ?? this.enrolledIds,
      rejectedIds: rejectedIds ?? this.rejectedIds,
      isGroupResearch: isGroupResearch ?? this.isGroupResearch,
      isRequestingParticipants:
          isRequestingParticipants ?? this.isRequestingParticipants,
      requestedParticipantsNumber:
          requestedParticipantsNumber ?? this.requestedParticipantsNumber,
      requestJoiners: requestJoiners ?? this.requestJoiners,
    );
  }

  factory Research.empty() => Research(
      researchId: "",
      researcher: Researcher.empty(),
      state: ResearchState.Upcoming,
      title: "",
      isGroupResearch: false,
      desc: "",
      category: "",
      criteria: {},
      questions: [],
      benefits: [],
      meetings: [],
      numberOfEnrolled: 0,
      numberOfMeetings: 0,
      city: "",
      preferredDays: [],
      preferredTimes: [],
      preferredMethods: [],
      startDate: DateTime.now().toString().substring(0, 10),
      phases: [],
      enrolledIds: [],
      sampleSize: 0,
      rejectedIds: []);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Research &&
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
        other.requestJoiners == requestJoiners;
  }

  @override
  int get hashCode {
    return researcher.hashCode ^
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
  }

  @override
  String toString() {
    return 'Research(researcher: $researcher, researchId: $researchId, state: $state, title: $title, desc: $desc, category: $category, criteria: $criteria, questions: $questions, benefits: $benefits, sampleSize: $sampleSize, numberOfMeetings: $numberOfMeetings, preferredTimes: $preferredTimes, preferredDays: $preferredDays, preferredMethods: $preferredMethods, startDate: $startDate, meetings: $meetings, city: $city, image: $image, numberOfEnrolled: $numberOfEnrolled, phases: $phases, enrolledIds: $enrolledIds, rejectedIds: $rejectedIds, isGroupResearch: $isGroupResearch, isRequestingParticipants: $isRequestingParticipants, requestedParticipantsNumber: $requestedParticipantsNumber, requestJoiners: $requestJoiners)';
  }
}

abstract class BaseResearch {
  Future<void> togglePhase(int index);
  Future<void> addMeeting(Meeting meeting);
  Future<void> stopRequest();
  Future<void> editRequest(int newNumber);
  Future<void> addParticipant(Participant participant);
  Future<void> addPhases(List<Phase> phases);

  Future<void> addEmptyGroup();
  void addUniqueBenefit(Benefit benefit, EnrolledTo enrollment);
  void addUnifiedBenefit(Benefit benefit);
  Future<void> removeMeeting(Meeting meeting);
  Future<void> editMeeting(int index, Meeting meeting);
  Future<void> requestParticipants(int number);
  Future<void> kickParticipant(String participantId);

  Future<void> changeParticipantGroup({
    required int participantIndex,
    required int fromIndex,
    required int toIndex,
  });

  Future<void> removeGroup(int groupIndex);
}
