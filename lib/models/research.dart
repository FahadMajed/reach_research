import 'dart:core';
import 'dart:math';

import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum ResearchState { Upcoming, Ongoing, Redeeming, Done }

//TODO Create empty constructor

class Research {
  final Researcher researcher;

  String? researchId;
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

  factory Research.fromFirestore(Map researchData) {
    Map<String, Criterion> criteria = {};

    for (String key in researchData['criteria'].keys) {
      criteria[key] = criterionFromMap(researchData['criteria'][key]);
    }

    return Research(
      researchId: researchData['researchId'] ?? '',
      isGroupResearch: researchData["isGroupResearch"] ?? false,
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
        'researchId': researchId ?? "",
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

  String getImage(String category) {
    Random rnd = Random();
    int min = 1;
    int max = 7;

    int number = min + rnd.nextInt(max - min);

    return '$category${number.toString()}.webp';
  }

  bool scheduleIsNotEmpty() =>
      preferredDays.isNotEmpty &&
      preferredTimes.isNotEmpty &&
      preferredMethods.isNotEmpty &&
      startDate != DateTime.now().toString().substring(0, 10);

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
}

abstract class BaseOngoingResearch {
  Future<void> togglePhase(int index);
  Future<void> addMeeting(Meeting meeting);
  Future<void> addEmptyGroup();
  Future<void> deleteMeeting(Meeting meeting);
  Future<void> editMeeting(int index, Meeting meeting);
  Future<void> requestParticipants(int number);
  Future<void> kickParticipant(String participantId);
  Future<void> changeParticipantGroup(
      {required int participantIndex,
      required int prevIndex,
      required int newIndex});
  Future<void> changeGroupName(int groupIndex, String newName);
  Future<void> deleteGroup(int groupIndex);
}
