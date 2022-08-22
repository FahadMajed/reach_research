import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/models/models.dart';
import 'package:reach_research/research.dart';

final researchPvdr = StateNotifierProvider<ResearchNotifier, Research>(
  (ref) => ResearchNotifier(
    ref.read(
      researchsRepoPvdr,
    ),
  ),
);

//after creation
class ResearchNotifier extends BaseResearchNotifier
    with GroupReserchNotifier, SingularResearchNotifier
    implements BaseResearch {
  ResearchNotifier(super.repository);

  @override
  Research get research =>
      state is SingularResearch ? state : state as GroupResearch;

  @override
  Future<void> addParticipant(Participant participant) async {
    if (research.sampleSize == research.numberOfEnrolled) {
      throw ResearchIsFull();
    }
    if (research.isGroupResearch) {
      addParticipantToGroup(participant);
    } else {
      addParticipantToSingle(participant);
    }

    _incrementEnrollments(participantId: participant.participantId);

    if (research.isRequestingParticipants) {
      _incrementRequestJoiners();

      if (research.requestedParticipantsNumber == research.requestJoiners) {
        stopRequest();
        return;
      }
    }

    await updateData();
  }

  @override
  void addUnifiedBenefit(Benefit benefit) {
    if (state is GroupResearch) {
      addGroupUnifiedBenefit(benefit);
    } else {
      addSingularUnifiedBenefit(benefit);
    }
  }

  @override
  void addUniqueBenefit(
    Benefit benefit,
    Enrollment enrollment,
  ) {
    if (state is GroupResearch) {
      addGroupUniqueBenefit(enrollment, benefit);
    } else if (state is SingularResearch) {
      addSingularUniqueBenefit(enrollment, benefit);
    }
  }

  @override
  Future<void> addMeeting(Meeting meeting) async {
    updateState(meetings: [...research.meetings, meeting]);
    await updateData();
  }

  @override
  Future<void> removeMeeting(Meeting meeting) async {
    updateState(meetings: research.meetings..remove(meeting));
    await updateData();
  }

  @override
  Future<void> editMeeting(int index, Meeting meeting) async {
    final meetings = research.meetings;
    updateState(
      meetings: [
        for (final m in meetings)
          if (meetings.indexOf(m) == index) meeting else m,
      ],
    );

    await updateData();
  }

  @override
  Future<void> togglePhase(
    int index,
  ) async {
    final phases = research.phases;
    updateState(
      phases: [
        for (final p in phases)
          if (phases.indexOf(p) == index)
            p.copyWith(isChecked: !p.isChecked)
          else
            p,
      ],
    );

    await updateData();
  }

  @override
  Future<void> kickParticipant(String participantId) async {
    if (state is GroupResearch) {
      kickParticipantFromGroup(participantId);
    } else {
      kickParticipantFromEnrollments(participantId);
    }

    decrementEnrollments(participantId: participantId);

    await updateData();
  }

  @override
  Future<void> requestParticipants(int number) async {
    updateState(
      requestJoiners: 0,
      sampleSize: research.numberOfEnrolled + number,
      requestedParticipantsNumber: number,
      isRequestingParticipants: true,
    );

    await updateData();
  }

  @override
  Future<void> stopRequest() async {
    updateState(
        isRequestingParticipants: false,
        sampleSize: research.numberOfEnrolled,
        requestedParticipantsNumber: 0,
        requestJoiners: 0);

    await updateData();
  }

  Future<void> updateResearchState(ResearchState newState) async {
    updateState(
      researchState: newState,
    );

    await updateData();
  }

  @override
  Future<void> addPhases(List<Phase> phases) async {
    updateState(
      researchState: ResearchState.ongoing,
      phases: phases,
    );

    await updateData();
  }

  @override
  Future<void> editRequest(int newNumber) async {
    updateState(requestedParticipantsNumber: newNumber);
    await updateData();
  }

  void _incrementEnrollments({required String participantId}) => updateState(
        numberOfEnrolled: research.numberOfEnrolled + 1,
        enrolledIds: [
          ...research.enrolledIds,
          participantId,
        ],
      );

  void _incrementRequestJoiners() => updateState(
        requestJoiners: research.requestJoiners + 1,
      );

  Future<void> endResearch() async {
    updateState(
      researchState: ResearchState.redeeming,
    );

    await updateData();
  }
}
