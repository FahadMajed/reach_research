import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class BaseResearchNotifier extends StateNotifier<Research> {
  @protected
  final ResearchsRepository repository;
  BaseResearchNotifier(this.repository) : super(Research.empty()) {
    state = Research.empty();
  }

  Research get research =>
      state is SingularResearch ? state : state as GroupResearch;

  void set(Research research) => state = research;
  @protected
  Future<void> updateData() async =>
      await repository.updateData(research, research.researchId);

  @protected
  Future<void> updateField(String fieldName, dynamic fieldData) async =>
      await repository.updateField(research.researchId, fieldName, fieldData);

  @protected
  void updateState({
    List<Enrollment>? enrollments,
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
    List<Group>? groups,
  }) =>
      state = copyResearchWith(
        state,
        enrollments: enrollments,
        numberOfGroups: numberOfGroups,
        groupSize: groupSize,
        groups: groups,
        researcher: researcher,
        researchId: researchId,
        researchState: researchState,
        title: title,
        desc: desc,
        requestJoiners: requestJoiners,
        category: category,
        criteria: criteria,
        questions: questions,
        benefits: benefits,
        sampleSize: sampleSize,
        numberOfMeetings: numberOfMeetings,
        meetingsDays: meetingsDays,
        meetingsTimeSlots: meetingsTimeSlots,
        meetingsMethods: meetingsMethods,
        startDate: startDate,
        meetings: meetings,
        city: city,
        isRequestingParticipants: isRequestingParticipants,
        requestedParticipantsNumber: requestedParticipantsNumber,
        image: image,
        numberOfEnrolled: numberOfEnrolled,
        phases: phases,
        enrolledIds: enrolledIds,
        rejectedIds: rejectedIds,
        isGroupResearch: isGroupResearch,
      );

  @protected
  void decrementEnrollments({required String participantId}) => updateState(
        numberOfEnrolled: research.numberOfEnrolled - 1,
        enrolledIds: [
          ...research.enrolledIds
            ..remove(
              participantId,
            ),
        ],
      );
}
