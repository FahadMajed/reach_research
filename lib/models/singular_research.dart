import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class SingularResearch extends Research {
  final List<EnrolledTo> enrollments;

  SingularResearch(
      {required this.enrollments,
      researchId,
      state,
      title = '',
      desc = '',
      image,
      questions,
      numberOfEnrolled,
      sampleSize,
      benefits,
      List<Meeting> meetings = const [],
      numberOfMeetings,
      preferredDays,
      preferredTimes,
      preferredMethods,
      enrolledIds,
      city = "",
      criteria,
      List<Phase> phases = const [],
      researcher,
      category = '',
      rejectedIds = const [],
      isGroupResearch = false,
      bool isRequestingParticipants = false,
      int requestedParticipantsNumber = 0,
      int requestJoiners = 0,
      startDate})
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
            criteria: criteria,
            phases: phases,
            researcher: researcher,
            category: category,
            isGroupResearch: isGroupResearch,
            rejectedIds: rejectedIds,
            isRequestingParticipants: isRequestingParticipants,
            requestedParticipantsNumber: requestedParticipantsNumber,
            requestJoiners: requestJoiners,
            startDate: startDate);

  void addUniqueBenefit(EnrolledTo enrollment, Benefit benefitToInsert) {
    bool alreadyInserted = false;

    for (final benefit in enrollment.benefits) {
      if (benefit.benefitName == benefitToInsert.benefitName) {
        alreadyInserted = true;
      }
    }
    int partIndex = getParticipantIndex(
      enrollment.participant.participantId,
    );
    if (alreadyInserted) {
      removeBenefit(
        partIndex,
        benefitToInsert.benefitName,
      );
    }

    enrollments[partIndex].benefits.add(benefitToInsert);
  }

  List<Participant> getParticipants() =>
      [for (final e in enrollments) e.participant];

  int getParticipantIndex(String participantId) => enrollments
      .indexWhere((e) => e.participant.participantId == participantId);

  void removeBenefit(int index, String benefitName) => enrollments[index]
      .benefits
      .removeWhere((b) => b.benefitName == benefitName);

  @override
  toMap() {
    Map data = super.toMap();
    data["enrollments"] = enrollments.map((x) => x.toMap()).toList();
    return data;
  }

  @override
  toPartialMap() {
    Map data = super.toPartialMap();
    data["enrollments"] = enrollments.map((x) => x.toMap()).toList();
    return data;
  }

  factory SingularResearch.fromFirestore(Map<String, dynamic> researchData) {
    Map<String, Criterion> criteria = {};

    if (researchData['criteria'] != null) {
      for (String key in researchData['criteria'].keys) {
        criteria[key] = criterionFromMap(researchData['criteria'][key]);
      }
    }

    return SingularResearch(
      enrollments: (researchData["enrollments"] as List)
          .map((v) => EnrolledTo.fromFirestore(v))
          .toList(),
      isGroupResearch: false,
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

  factory SingularResearch.copy(Research research) => SingularResearch(
        sampleSize: research.sampleSize,
        researcher: research.researcher,
        researchId: "",
        enrollments: [],
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
        isGroupResearch: false,
      );

  SingularResearch copyWith2({
    List<EnrolledTo>? enrollments,
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
    String? languageCode,
    String? image,
    int? numberOfEnrolled,
    List<Phase>? phases,
    List? enrolledIds,
    List? rejectedIds,
    bool? isGroupResearch,
    int? requestJoiners,
    bool? isRequestingParticipants,
    int? requestedParticipantsNumber,
  }) =>
      SingularResearch(
          enrollments: enrollments ?? this.enrollments,
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
          city: city ?? this.city,
          image: image ?? this.image,
          numberOfEnrolled: numberOfEnrolled ?? this.numberOfEnrolled,
          phases: phases ?? this.phases,
          enrolledIds: enrolledIds ?? this.enrolledIds,
          rejectedIds: rejectedIds ?? this.rejectedIds,
          isGroupResearch: isGroupResearch ?? this.isGroupResearch,
          requestJoiners: requestJoiners ?? this.requestJoiners,
          requestedParticipantsNumber:
              requestedParticipantsNumber ?? this.requestedParticipantsNumber,
          isRequestingParticipants:
              isRequestingParticipants ?? this.isRequestingParticipants);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingularResearch &&
        listEquals(other.enrollments, enrollments);
  }

  @override
  int get hashCode => enrollments.hashCode;

  @override
  String toString() =>
      '${super.toString()} SingularResearch(enrollments: $enrollments)';
}
