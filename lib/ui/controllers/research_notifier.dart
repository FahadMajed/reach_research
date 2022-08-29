import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/use_cases/research/remove_participants.dart';
import 'package:reach_research/research.dart';

//after creation
class ResearchNotifier extends StateNotifier<AsyncValue<Research>>
    implements BaseResearch {
  Research get research => state.value ?? Research.empty();
  final String researcherId;

  void set(Research research) => state = AsyncData(research);

  ResearchNotifier({
    required this.researcherId,
    required this.addParticipantToResearch,
    required this.addResearchUseCase,
    required this.addMeetingUseCase,
    required this.removeMeetingUseCase,
    required this.updateMeetingUseCase,
    required this.requestParticipantsUseCase,
    required this.stopRequestUseCase,
    required this.updateParticipantsRequestUseCase,
    required this.startResearchUseCase,
    required this.endResearchUseCase,
    required this.kickParticipantUseCase,
    required this.togglePhaseUseCase,
    required this.getResearchUseCase,
    required this.removeParticipantsUseCase,
  }) : super(const AsyncLoading()) {
    if (researcherId.isNotEmpty) getResearch();
  }

  final GetResearch getResearchUseCase;

  final AddResearch addResearchUseCase;

  final AddParticipantToResearch addParticipantToResearch;

  final StartResearch startResearchUseCase;

  final TogglePhase togglePhaseUseCase;

  final AddMeeting addMeetingUseCase;
  final RemoveMeeting removeMeetingUseCase;
  final UpdateMeeting updateMeetingUseCase;

  final RemoveParticipants removeParticipantsUseCase;
  final KickParticipant kickParticipantUseCase;

  final RequestParticipants requestParticipantsUseCase;
  final StopRequest stopRequestUseCase;
  final UpdateParticipantsRequest updateParticipantsRequestUseCase;

  final EndResearch endResearchUseCase;

  @override
  Future<void> getResearch() async => await getResearchUseCase
      .call(
        GetResearchParams(researcherId: researcherId),
      )
      .then(
        (research) => state = AsyncData(research),
        onError: (e) => state = AsyncError(e),
      );

  @override
  Future<void> addResearch(Research research) async => await addResearchUseCase
      .call(
        AddResearchParams(research: research),
      )
      .then(
        (research) => state = AsyncData(research),
        onError: (e) => state = AsyncError(e),
      );

  @override
  Future<void> addParticipant(Participant participant) async =>
      await addParticipantToResearch
          .call(AddParticipantToResearchParams(
            participant: participant,
            research: research,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  ///[enrollmentsResearcherChattedIds] are those peer chats that will be added to
  ///research chat, the scenario is, researcher chatted with participant
  ///before enrollment, then this participant enrolled to researcher research,
  ///so, his chat will be visible in the research
  @override
  Future<void> startResearch(
    List<Phase> phases,
    List enrollmentsResearcherChattedIds,
  ) async =>
      await startResearchUseCase
          .call(StartResearchParams(
            phases: phases,
            research: research,
            enrollmentsResearcherChattedIds: enrollmentsResearcherChattedIds,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> addMeeting(Meeting meeting) async => addMeetingUseCase
      .call(AddMeetingParams(
        meeting: meeting,
        researchId: research.researchId,
      ))
      .then(
        (meeting) => updateState(meetings: [...research.meetings, meeting]),
        onError: (e) => state = AsyncError(e),
      );

  @override
  Future<void> removeMeeting(Meeting meeting) async => removeMeetingUseCase
      .call(RemoveMeetingParams(
        meeting: meeting,
        researchId: research.researchId,
      ))
      .then(
        (_) => updateState(meetings: research.meetings..remove(meeting)),
        onError: (e) => state = AsyncError(e),
      );

  @override
  Future<void> updateMeeting(int index, Meeting meeting) async =>
      await updateMeetingUseCase
          .call(UpdateMeetingParams(
            meeting: meeting,
            researchId: research.researchId,
          ))
          .then(
            (_) => updateState(meetings: [
              for (final m in research.meetings)
                if (research.meetings.indexOf(m) == index) meeting else m,
            ]),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> togglePhase(
    int index,
  ) async =>
      togglePhaseUseCase
          .call(TogglePhaseParams(
            research: research,
            phaseIndex: index,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> removeParticipants(List toRemoveIds) async =>
      await removeParticipantsUseCase
          .call(RemoveParticipantsParams(
            research: research,
            toRemoveIds: toRemoveIds,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> kickParticipant(String participantId) async =>
      await kickParticipantUseCase
          .call(KickParticipantParams(
            participantId: participantId,
            research: research,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> requestParticipants(int number) async =>
      await requestParticipantsUseCase
          .call(RequestParticipantsParams(
            requestedParticipantsNumber: number,
            research: research,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> updateParticipantsRequest(int newNumber) async =>
      await updateParticipantsRequestUseCase
          .call(UpdateParticipantsRequestParams(
            research: research,
            newNumber: newNumber,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> stopRequest() async => await stopRequestUseCase
      .call(
        StopRequestParams(research: research),
      )
      .then(
        (research) => state = AsyncData(research),
        onError: (e) => state = AsyncError(e),
      );

  @override
  Future<void> endResearch() async => await endResearchUseCase
      .call(
        EndResearchParams(research: research),
      )
      .then(
        (_) => state = AsyncData(Research.empty()),
        onError: (e) => state = AsyncError(e),
      );

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
      state = AsyncData(
        copyResearchWith(
          state.value!,
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
        ),
      );
}
