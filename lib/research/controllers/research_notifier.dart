import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

//after creation
class ResearchNotifier extends StateNotifier<AsyncValue<Research?>>
    implements BaseResearch {
  final Reader read;

  Research get research => state.value!;
  late final String _uid;

  get researchId => research.researchId;

  void set(Research research) => state = AsyncData(research);

  ResearchNotifier({
    required this.read,
    required String uid,
    required bool isResearcher,
  }) : super(const AsyncLoading()) {
    _uid = uid;
    _addParticipantToResearch = read(addParticipantToResearchPvdr);
    _addResearch = read(addResearchPvdr);
    _getMeetings = read(getMeetingsPvdr);
    _addMeeting = read(addMeetingPvdr);
    _removeMeeting = read(removeMeetingPvdr);
    _updateMeeting = read(updateMeetingPvdr);
    _requestParticipants = read(requestParticipantsPvdr);
    _stopRequest = read(stopRequestPvdr);
    _updateParticipantsRequest = read(updateParticipantsRequestPvdr);
    _startResearch = read(startResearchPvdr);
    _endResearch = read(endResearchPvdr);
    _kickParticipant = read(kickParticipantPvdr);
    _togglePhase = read(togglePhasePvdr);
    _getResearch = read(getResearchPvdr);
    _removeParticipants = read(removeParticipantsPvdr);
    _getEnrolledResearch = read(getEnrolledResearchPvdr);

    _removeResearch = read(removeResearchPvdr);

    if (uid.isNotEmpty) {
      if (isResearcher) {
        getResearch();
      } else {
        getEnrolledResearch();
      }
    }
  }

  late final GetResearch _getResearch;
  late final GetEnrolledResearch _getEnrolledResearch;

  late final AddResearch _addResearch;

  late final AddParticipantToResearch _addParticipantToResearch;

  late final StartResearch _startResearch;

  late final TogglePhase _togglePhase;

  late final GetMeetings _getMeetings;
  late final AddMeeting _addMeeting;
  late final RemoveMeeting _removeMeeting;
  late final UpdateMeeting _updateMeeting;

  late final RemoveParticipants _removeParticipants;
  late final KickParticipant _kickParticipant;

  late final RequestParticipants _requestParticipants;
  late final StopRequest _stopRequest;
  late final UpdateParticipantsRequest _updateParticipantsRequest;

  late final EndResearch _endResearch;

  late final RemoveResearch _removeResearch;

  ParticipantNotifier get participantNotifier => read(partPvdr.notifier);
  ResearcherNotifier get researcherNotifier => read(researcherPvdr.notifier);
  GroupsNotifier get groupsNotifier => read(groupsPvdr.notifier);
  EnrollmentsNotifier get enrollmentsNotifier => read(enrollmentsPvdr.notifier);

  @override
  Future<void> getResearch() async {
    state = const AsyncLoading();

    await _getResearch
        .call(
          GetResearchParams(researcherId: _uid),
        )
        .then(
          (research) => state = AsyncData(research),
          onError: (e) => state = AsyncError(e),
        );
  }

  @override
  Future<void> getEnrolledResearch() async {
    state = const AsyncLoading();
    await _getEnrolledResearch
        .call(
          GetEnrolledResearchParams(participantId: _uid),
        )
        .then(
          (research) => state = AsyncData(research ?? Research.empty()),
          onError: (e) => state = AsyncError(e),
        );
  }

  @override
  Future<void> addResearch(Research research) async {
    researchLoading();
    await _addResearch
        .call(
      AddResearchParams(research: research),
    )
        .then(
      (research) {
        //UPDATE
        researcherNotifier.getResearcher();
        state = AsyncData(research);
      },
      onError: (e) => onResearchError(e),
    );

    researchLoaded();
  }

  @override
  Future<void> addParticipant(Participant participant) async {
    researchLoading();
    await _addParticipantToResearch
        .call(AddParticipantToResearchParams(
      participant: participant,
      research: research,
    ))
        .then(
      (research) {
        participantNotifier.getParticipant();
        if (research is GroupResearch) {
          groupsNotifier.getGroups();
        } else {
          enrollmentsNotifier.getEnrollmentsForResearch();
        }
        state = AsyncData(research);
      },
      onError: (e) => onResearchError(e),
    );

    researchLoaded();
  }

  ///[enrollmentsResearcherChattedIds] are those peer chats that will be added to
  ///research chat, the scenario is, researcher chatted with participant
  ///before enrollment, then this participant enrolled to researcher research,
  ///so, his chat will be visible in the research
  @override
  Future<void> startResearch(
    List<Phase> phases, {
    List? enrollmentsResearcherChattedIds,
  }) async {
    researchLoading();
    await _startResearch
        .call(StartResearchParams(
          phases: phases,
          research: research,
          enrollmentsResearcherChattedIds: enrollmentsResearcherChattedIds,
        ))
        .then(
          (research) => state = AsyncData(research),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> getMeetings({bool isRefreseshing = false}) async {
    if (isRefreseshing == true || research.meetings.isEmpty) {
      researchLoading();
      await _getMeetings.call(GetMeetingsParams(researchId: researchId)).then(
            (meetings) => updateState(meetings: meetings),
            onError: (e) => onResearchError(e),
          );
      researchLoaded();
    }
  }

  @override
  Future<void> addMeeting(Meeting meeting) async {
    researchLoading();
    _addMeeting
        .call(AddMeetingParams(
          meeting: meeting,
          researchId: researchId,
        ))
        .then(
          (meeting) => updateState(meetings: [...research.meetings, meeting]),
          onError: (e) => onResearchError(e),
        );

    researchLoaded();
  }

  @override
  Future<void> removeMeeting(Meeting meeting) async {
    researchLoading();
    _removeMeeting
        .call(RemoveMeetingParams(
          meeting: meeting,
          researchId: researchId,
        ))
        .then(
          (_) => updateState(meetings: research.meetings..remove(meeting)),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> updateMeeting(int index, Meeting meeting) async {
    researchLoading();
    await _updateMeeting
        .call(UpdateMeetingParams(
          meeting: meeting,
          researchId: researchId,
        ))
        .then(
          (_) => updateState(meetings: [
            for (final m in research.meetings)
              if (research.meetings.indexOf(m) == index) meeting else m,
          ]),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> togglePhase(
    int index,
  ) async =>
      await _togglePhase
          .call(TogglePhaseParams(
            research: research,
            phaseIndex: index,
          ))
          .then(
            (research) => state = AsyncData(research),
            onError: (e) => onResearchError(e),
          );

  // @override
  // Future<void> removeParticipants(List toRemoveIds) async {
  //   researchLoading();
  //   await _removeParticipants
  //       .call(RemoveParticipantsParams(
  //         research: research,
  //         toRemoveIds: toRemoveIds,
  //       ))
  //       .then(
  //         (research) => state = AsyncData(research),
  //         onError: (e) => onResearchError(e),
  //       );
  //   researchLoaded();
  // }

  @override
  Future<void> kickParticipant(String participantId) async {
    researchLoading();
    await _kickParticipant
        .call(KickParticipantParams(
          participantId: participantId,
          research: research,
        ))
        .then(
          (research) => state = AsyncData(research),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> requestParticipants(int number) async {
    researchLoading();
    await _requestParticipants
        .call(RequestParticipantsParams(
          requestedParticipantsNumber: number,
          research: research,
        ))
        .then(
          (research) => state = AsyncData(research),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> updateParticipantsRequest(int newNumber) async {
    researchLoading();
    await _updateParticipantsRequest
        .call(UpdateParticipantsRequestParams(
          research: research,
          newNumber: newNumber,
        ))
        .then(
          (research) => state = AsyncData(research),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> stopRequest() async {
    researchLoading();
    await _stopRequest
        .call(
          StopRequestParams(research: research),
        )
        .then(
          (research) => state = AsyncData(research),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> endResearch() async {
    researchLoading();
    await _endResearch
        .call(
          EndResearchParams(research: research),
        )
        .then(
          (_) => state = const AsyncData(null),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

  @override
  Future<void> removeResearch() async {
    researchLoading();
    await _removeResearch
        .call(RemoveResearchParams(
          researchId: researchId,
          enrolledIds: research.enrolledIds,
          researcherId: research.researcher.researcherId,
        ))
        .then(
          (_) => state = const AsyncData(null),
          onError: (e) => onResearchError(e),
        );
    researchLoaded();
  }

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

  void onResearchError(e) {
    researchLoaded();
    throw e;
  }
}

final RxBool isResearchLoading = false.obs;

void researchLoading() => isResearchLoading.value = true;
void researchLoaded() => isResearchLoading.value = false;
