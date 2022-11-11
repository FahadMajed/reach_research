// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum ResearchState { upcoming, ongoing, redeeming, done }

class Research {
  final Researcher researcher;

  final String researchId;

  final ResearchState researchState;

  final String title;
  final String desc;
  final String category;

  final Criteria criteria;

  final List<CustomizedQuestion> questions;

  final List<Benefit> benefits;

  final bool isGroupResearch;

  final int numberOfEnrolled;

  final int sampleSize;

  final Schedule schedule;

  final String image;

  final List enrolledIds;
  final List rejectedIds;

  final List<Phase> phases;

  final List<Meeting> meetings;

  late final ParticipantsRequest partsRequest;

  Research({
    required this.researcher,
    required this.researchId,
    required this.title,
    required this.desc,
    required this.category,
    required this.researchState,
    required this.criteria,
    required this.questions,
    required this.benefits,
    required this.isGroupResearch,
    required this.numberOfEnrolled,
    required this.sampleSize,
    required this.schedule,
    required this.image,
    required this.enrolledIds,
    required this.phases,
    required this.meetings,
    required this.rejectedIds,
    ParticipantsRequest? partsRequest,
  }) {
    if (partsRequest == null) {
      this.partsRequest = ParticipantsRequest.empty();
    } else {
      this.partsRequest = partsRequest;
    }
  }

  factory Research.empty() => Research(
        researchId: "1",
        researcher: Researcher.empty(),
        researchState: ResearchState.upcoming,
        title: "",
        desc: "",
        isGroupResearch: false,
        image: 'Economics1.webp',
        category: "",
        criteria: criteriaDefaultRanges,
        questions: const [],
        benefits: const [],
        meetings: const [],
        numberOfEnrolled: 0,
        schedule: Schedule(
            meetingsDays: [],
            meetingsMethods: [],
            meetingsTimeSlots: [],
            startDate: DateTime.now().toString().substring(0, 10),
            numberOfMeetings: 0),
        phases: const [],
        enrolledIds: const [],
        rejectedIds: [],
        sampleSize: 5,
      );

  bool get isNotFull => sampleSize > numberOfEnrolled;

  bool get isOngoing => researchState == ResearchState.ongoing;

  bool get isUpcoming => researchState == ResearchState.upcoming;

  String get researcherId => researcher.researcherId;

  bool canAcceptParticipant(String participantId) {
    return (isUpcoming && isNotFull) || partsRequest.isActive && _researchHaveNotHad(participantId);
  }

  ///////////////////////////////////////

  bool enrolledIdsContains(String participantId) => enrolledIds.contains(participantId);

  ///WHEN DONE
  Research removeParticipant(String participantId) =>
      copyResearchWith(this, enrolledIds: enrolledIds..remove(participantId));

  Research kickParticipant(String participantId) {
    return copyResearchWith(this,
        enrolledIds: enrolledIds..remove(participantId), numberOfEnrolled: numberOfEnrolled - 1);
  }

  Research addEnrollment(String partId) {
    ParticipantsRequest _partRequest = partsRequest;

    if (_partRequest.isActive) {
      _partRequest = _partRequest.incrementJoiners();
      if (_partRequest.isFullfilled) {
        _partRequest = _partRequest.stop();
      }
    }

    Research updatedResearch = copyResearchWith(this,
        enrolledIds: [...enrolledIds, partId], numberOfEnrolled: numberOfEnrolled + 1, partsRequest: _partRequest);

    return updatedResearch;
  }

  Research updateParticipantsRequest(int numberOfRequested) => copyResearchWith(this,
      partsRequest: partsRequest.copyWith(
        numberOfRequested: numberOfRequested,
      ),
      sampleSize: numberOfEnrolled + numberOfRequested);

  Research startParticipantsRequest(int numberOfRequested) => copyResearchWith(this,
      partsRequest: ParticipantsRequest(
        numberOfRequested: numberOfRequested,
        requestJoiners: 0,
      ),
      sampleSize: numberOfEnrolled + numberOfRequested);

  Research stopParticipantsRequest() => copyResearchWith(
        this,
        partsRequest: ParticipantsRequest.empty(),
      );

  Research copyWith({
    Researcher? researcher,
    String? researchId,
    ResearchState? researchState,
    String? title,
    String? desc,
    String? category,
    Map<String, Criterion>? criteria,
    List<CustomizedQuestion>? questions,
    List<Benefit>? benefits,
    bool? isGroupResearch,
    int? numberOfEnrolled,
    int? sampleSize,
    Schedule? schedule,
    String? image,
    List? enrolledIds,
    List? rejectedIds,
    List<Phase>? phases,
    List<Meeting>? meetings,
    ParticipantsRequest? partsRequest,
  }) {
    return Research(
      researcher: researcher ?? this.researcher,
      researchId: researchId ?? this.researchId,
      researchState: researchState ?? this.researchState,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      category: category ?? this.category,
      criteria: criteria ?? this.criteria,
      questions: questions ?? this.questions,
      benefits: benefits ?? this.benefits,
      isGroupResearch: isGroupResearch ?? this.isGroupResearch,
      numberOfEnrolled: numberOfEnrolled ?? this.numberOfEnrolled,
      sampleSize: sampleSize ?? this.sampleSize,
      schedule: schedule ?? this.schedule,
      image: image ?? this.image,
      enrolledIds: enrolledIds ?? this.enrolledIds,
      phases: phases ?? this.phases,
      rejectedIds: rejectedIds ?? this.rejectedIds,
      meetings: meetings ?? this.meetings,
      partsRequest: partsRequest ?? this.partsRequest,
    );
  }

  void addRejectedId(String participantId) {
    rejectedIds.add(participantId);
  }

  bool _researchHaveNotHad(String participantId) =>
      enrolledIds.contains(participantId) == false && rejectedIds.contains(participantId) == false;

  Research start(List<Phase> phases) => copyResearchWith(
        this,
        phases: phases,
        researchState: ResearchState.ongoing,
      );

  Research removeParticipants(List toRemoveIds) => copyResearchWith(
        this,
        enrolledIds: [
          for (final id in enrolledIds)
            if (toRemoveIds.contains(id) == false) id
        ],
        numberOfEnrolled: numberOfEnrolled - toRemoveIds.length,
      );

  Research removeMeeting(Meeting meeting) => copyResearchWith(this, meetings: meetings..remove(meeting));

  factory Research.initWithCriteria({
    RangeCriterion? age,
    RangeCriterion? height,
    RangeCriterion? weight,
    RangeCriterion? income,
    ValueCriterion? gender,
    ValueCriterion? nation,
  }) =>
      Research.empty().copyWith(criteria: {
        if (age != null) "age": age,
        if (height != null) "height": height,
        if (weight != null) "weight": weight,
        if (income != null) "income": income,
        if (gender != null) "gender": gender,
        if (nation != null) "nation": nation,
      });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Research &&
        other.researcher == researcher &&
        other.researchId == researchId &&
        other.researchState == researchState &&
        other.title == title &&
        other.desc == desc &&
        other.category == category &&
        other.criteria == criteria &&
        listEquals(other.questions, questions) &&
        listEquals(other.benefits, benefits) &&
        other.isGroupResearch == isGroupResearch &&
        other.numberOfEnrolled == numberOfEnrolled &&
        other.sampleSize == sampleSize &&
        other.schedule == schedule &&
        other.image == image &&
        listEquals(other.enrolledIds, enrolledIds) &&
        listEquals(other.rejectedIds, rejectedIds) &&
        listEquals(other.phases, phases) &&
        listEquals(other.meetings, meetings) &&
        other.partsRequest == partsRequest;
  }

  @override
  int get hashCode {
    return researcher.hashCode ^
        researchId.hashCode ^
        researchState.hashCode ^
        title.hashCode ^
        desc.hashCode ^
        category.hashCode ^
        criteria.hashCode ^
        questions.hashCode ^
        benefits.hashCode ^
        isGroupResearch.hashCode ^
        numberOfEnrolled.hashCode ^
        sampleSize.hashCode ^
        schedule.hashCode ^
        image.hashCode ^
        enrolledIds.hashCode ^
        rejectedIds.hashCode ^
        phases.hashCode ^
        meetings.hashCode ^
        partsRequest.hashCode;
  }

  @override
  String toString() {
    return 'Research(researcher: $researcher, researchId: $researchId, researchState: $researchState, title: $title, desc: $desc, category: $category, criteria: $criteria, questions: $questions, benefits: $benefits, isGroupResearch: $isGroupResearch, numberOfEnrolled: $numberOfEnrolled, sampleSize: $sampleSize, schedule: $schedule, image: $image, enrolledIds: $enrolledIds, rejectedIds: $rejectedIds, phases: $phases, meetings: $meetings, partsRequest: $partsRequest)';
  }
}
