import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/use_cases/research/get_enrolled_research.dart';
import 'package:reach_research/research.dart';

//after creation
class ResearchNotifier extends StateNotifier<AsyncValue<Research>>
    implements BaseResearch {
  Research get research => state.value!;
  late final String _uid;

  void set(Research research) => state = AsyncData(research);

  ResearchNotifier({
    required String uid,
    required bool isResearcher,
    required AddParticipantToResearch addParticipantToResearch,
    required AddResearch addResearch,
    required AddMeeting addMeeting,
    required RemoveMeeting removeMeeting,
    required UpdateMeeting updateMeeting,
    required RequestParticipants requestParticipants,
    required StopRequest stopRequest,
    required UpdateParticipantsRequest updateParticipantsRequest,
    required StartResearch startResearch,
    required EndResearch endResearch,
    required KickParticipant kickParticipant,
    required TogglePhase togglePhase,
    required GetResearch getResearch,
    required RemoveParticipants removeParticipants,
    required GetEnrolledResearch getEnrolledResearch,
  }) : super(const AsyncLoading()) {
    _uid = uid;
    _addParticipantToResearch = addParticipantToResearch;
    _addResearch = addResearch;
    _addMeeting = addMeeting;
    _removeMeeting = removeMeeting;
    _updateMeeting = updateMeeting;
    _requestParticipants = requestParticipants;
    _stopRequest = stopRequest;
    _updateParticipantsRequest = updateParticipantsRequest;
    _startResearch = startResearch;
    _endResearch = endResearch;
    _kickParticipant = kickParticipant;
    _togglePhase = togglePhase;
    _getResearch = getResearch;
    _removeParticipants = removeParticipants;
    _getEnrolledResearch = getEnrolledResearch;

    if (uid.isNotEmpty) {
      if (isResearcher) {
        this.getResearch();
      } else {
        this.getEnrolledResearch();
      }
    }
  }

  late final GetResearch _getResearch;
  late final GetEnrolledResearch _getEnrolledResearch;

  late final AddResearch _addResearch;

  late final AddParticipantToResearch _addParticipantToResearch;

  late final StartResearch _startResearch;

  late final TogglePhase _togglePhase;

  late final AddMeeting _addMeeting;
  late final RemoveMeeting _removeMeeting;
  late final UpdateMeeting _updateMeeting;

  late final RemoveParticipants _removeParticipants;
  late final KickParticipant _kickParticipant;

  late final RequestParticipants _requestParticipants;
  late final StopRequest _stopRequest;
  late final UpdateParticipantsRequest _updateParticipantsRequest;

  late final EndResearch _endResearch;

  @override
  Future<void> getResearch() async {
    state = const AsyncLoading();
    await _getResearch
        .call(
          GetResearchParams(researcherId: _uid),
        )
        .then(
          (research) => state = AsyncData(research ?? Research.empty()),
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
      (research) => state = AsyncData(research),
      onError: (e) {
        researchLoaded();
        throw e;
      },
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
      (research) => state = AsyncData(research),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

  ///[enrollmentsResearcherChattedIds] are those peer chats that will be added to
  ///research chat, the scenario is, researcher chatted with participant
  ///before enrollment, then this participant enrolled to researcher research,
  ///so, his chat will be visible in the research
  @override
  Future<void> startResearch(
    List<Phase> phases,
    List enrollmentsResearcherChattedIds,
  ) async {
    researchLoading();
    await _startResearch
        .call(StartResearchParams(
      phases: phases,
      research: research,
      enrollmentsResearcherChattedIds: enrollmentsResearcherChattedIds,
    ))
        .then(
      (research) => state = AsyncData(research),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

  @override
  Future<void> addMeeting(Meeting meeting) async {
    researchLoading();
    _addMeeting
        .call(AddMeetingParams(
      meeting: meeting,
      researchId: research.researchId,
    ))
        .then(
      (meeting) => updateState(meetings: [...research.meetings, meeting]),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

  @override
  Future<void> removeMeeting(Meeting meeting) async {
    researchLoading();
    _removeMeeting
        .call(RemoveMeetingParams(
      meeting: meeting,
      researchId: research.researchId,
    ))
        .then(
      (_) => updateState(meetings: research.meetings..remove(meeting)),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

  @override
  Future<void> updateMeeting(int index, Meeting meeting) async {
    researchLoading();
    await _updateMeeting
        .call(UpdateMeetingParams(
      meeting: meeting,
      researchId: research.researchId,
    ))
        .then(
      (_) => updateState(meetings: [
        for (final m in research.meetings)
          if (research.meetings.indexOf(m) == index) meeting else m,
      ]),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

  @override
  Future<void> togglePhase(
    int index,
  ) async {
    researchLoading();
    _togglePhase
        .call(TogglePhaseParams(
      research: research,
      phaseIndex: index,
    ))
        .then(
      (research) => state = AsyncData(research),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

  @override
  Future<void> removeParticipants(List toRemoveIds) async {
    researchLoading();
    await _removeParticipants
        .call(RemoveParticipantsParams(
      research: research,
      toRemoveIds: toRemoveIds,
    ))
        .then(
      (research) => state = AsyncData(research),
      onError: (e) {
        researchLoaded();
        throw e;
      },
    );
    researchLoaded();
  }

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
      onError: (e) {
        researchLoaded();
        throw e;
      },
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
      onError: (e) {
        researchLoaded();
        throw e;
      },
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
      onError: (e) {
        researchLoaded();
        throw e;
      },
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
      onError: (e) {
        researchLoaded();
        throw e;
      },
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
      (_) => state = AsyncData(Research.empty()),
      onError: (e) {
        researchLoaded();
        throw e;
      },
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
}

final RxBool isResearchLoading = false.obs;

void researchLoading() => isResearchLoading.value = true;
void researchLoaded() => isResearchLoading.value = false;
