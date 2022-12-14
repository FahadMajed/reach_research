import 'dart:core';

import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum ResearchState { upcoming, ongoing, redeeming, done }

class Research extends BaseModel<Research> {
  factory Research.empty() => Research({
        'researchId': "",
        'researcher': Researcher.empty().toMap(),
        'researchState': ResearchState.upcoming.index,
        'title': "",
        'isGroupResearch': false,
        'desc': "",
        "image": 'Economics1.webp',
        'category': "",
        'criteria': const {},
        'questions': const [],
        'benefits': const [],
        'meetings': const [],
        'numberOfEnrolled': 0,
        'numberOfMeetings': 0,
        'city': "",
        'meetingsDays': const [],
        'meetingsTimeSlots': const [],
        'meetingsMethods': const [],
        'startDate': DateTime.now().toString().substring(0, 10),
        'phases': const [],
        'enrolledIds': const [],
        'sampleSize': 0,
        'rejectedIds': const []
      });

  Research(Map<String, dynamic> jSON) : super(jSON);

  Researcher get researcher => Researcher(data['researcher']);

  String get researcherId => researcher.researcherId;

  String get researchId => data['researchId'];

  ResearchState get researchState =>
      ResearchState.values[data['researchState'] ?? 0];

  String get title => data['title'];
  String get desc => data['desc'];
  String get category => data['category'];

  Map<String, Criterion> get criteria => {
        for (final String criterion in data['criteria']!.keys)
          criterion: criterionFromMap(data['criteria'][criterion]),
      };

  List<Question> get questions =>
      (data['questions'] as List).map((e) => Question.fromMap(e)).toList();

  List<Benefit> get benefits =>
      (data['benefits'] as List).map((e) => Benefit.fromMap(e)).toList();

  bool get isGroupResearch => data['isGroupResearch'];
  int get sampleSize => data['sampleSize'];

  int get numberOfMeetings => data['numberOfMeetings'];

  List get meetingsTimeSlots => data['meetingsTimeSlots'];
  List get meetingsDays => data['meetingsDays'];
  List get meetingsMethods => data['meetingsMethods'];

  String get startDate => data['startDate'];

  String get city => data['city'];

  String get image => data['image'];

  int get numberOfEnrolled => data['numberOfEnrolled'];

  List get enrolledIds => data['enrolledIds'];
  List get rejectedIds => data['rejectedIds'] ?? [];

  List<Phase> get phases =>
      (data['phases'] as List).map((e) => Phase.fromFirestore(e)).toList();

  List<Meeting> get meetings =>
      (data['meetings'] as List).map((e) => Meeting.fromFirestore(e)).toList();

  bool get isRequestingParticipants =>
      data['isRequestingParticipants'] ?? false;
  int get requestedParticipantsNumber =>
      data['requestedParticipantsNumber'] ?? 0;
  int get requestJoiners => data['requestJoiners'] ?? 0;

  bool get isNotFull => sampleSize != numberOfEnrolled;

  @override
  String toString() => toMap().toString();

  @override
  Research copyWith(Map<String, dynamic> newData) => Research(
      {...data, ...newData..removeWhere((key, value) => value == null)});

  @override
  List<Object> get props => [toMap()];
//for duplication
  toPartialMap() => {
        "isGroupResearch": isGroupResearch,
        'researchId': researchId,
        'researchState': researchState.index,
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
  @override
  toMap() => {
        ...data,
        'researchState': researchState.index,
        'criteria': criteria
            .map((name, criteria) => MapEntry(name, criterionToMap(criteria))),
        'questions': questions.map((x) => x.toMap()).toList(),
        'benefits': benefits.map((x) => x.toMap()).toList(),
        'meetings': meetings.map((x) => x.toMap()).toList(),
        'phases': phases.map((x) => x.toMap()).toList(),
        'researcher': researcher.toResearchMap(),
      };
  ///////////////////////////////////////

  bool scheduleIsNotEmpty() =>
      meetingsDays.isNotEmpty &&
      meetingsTimeSlots.isNotEmpty &&
      meetingsMethods.isNotEmpty &&
      startDate != DateTime.now().toString().substring(0, 10);

  bool enrolledIdsContains(String participantId) =>
      enrolledIds.contains(participantId);

  void rejectParticipant(String participantId) =>
      rejectedIds.add(participantId);

  void removeParticipant(String participantId) {
    enrolledIds.remove(participantId);
  }

  Research get idenitifer => Research(data);
}
