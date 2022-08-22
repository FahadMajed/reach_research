import 'dart:core';

import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

enum ResearchState { upcoming, ongoing, redeeming, done }

class Research extends BaseModel<Research> {
  factory Research.empty() => Research({
        'researchId': "",
        'researcher': Researcher.empty(),
        'researchState': ResearchState.upcoming,
        'title': "",
        'isGroupResearch': false,
        'desc': "",
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
        'state': researchState.index,
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
        'researchId': researchId,
        "isGroupResearch": isGroupResearch,
        'state': researchState.index,
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
        "meetingsDays": meetingsDays,
        "meetingsTimeSlots": meetingsTimeSlots,
        "meetingsMethods": meetingsMethods,
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

  @override
  Research get idenitifer => Research(data);
}

abstract class BaseResearch {
  Future<void> togglePhase(int index);
  Future<void> addMeeting(Meeting meeting);
  Future<void> stopRequest();
  Future<void> editRequest(int newNumber);
  Future<void> addParticipant(Participant participant);
  Future<void> addPhases(List<Phase> phases);

  void addUniqueBenefit(Benefit benefit, Enrollment enrollment);
  void addUnifiedBenefit(Benefit benefit);
  Future<void> removeMeeting(Meeting meeting);
  Future<void> editMeeting(int index, Meeting meeting);
  Future<void> requestParticipants(int number);
  Future<void> kickParticipant(String participantId);
}

abstract class BaseGroupResearch {
  Future<void> changeParticipantGroup({
    required int participantIndex,
    required int fromIndex,
    required int toIndex,
  });

  Future<void> removeGroup(int groupIndex);

  Future<void> addEmptyGroup();
}
