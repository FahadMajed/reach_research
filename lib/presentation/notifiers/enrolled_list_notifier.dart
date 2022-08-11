import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrolledListNotifier extends StateNotifier<AsyncValue<List<Research>>> {
  final String uid;
  final ResearchsRepository repository;

  EnrolledListNotifier(this.uid, this.repository)
      : super(const AsyncValue.loading()) {
    getEnrolledToResearchs();
  }

  Future<void> getEnrolledToResearchs({isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    final researchs = await repository.getEnrolledToResearchs(uid);
    if (mounted) state = AsyncValue.data(researchs);
  }

  Future<void> updateResearch({required Research updatedResearch}) async {
    await repository.updateDocument(updatedResearch);

    state.whenData(
      (researchs) => state = AsyncValue.data(
        [
          for (final research in researchs)
            if (research.researchId == updatedResearch.researchId &&
                updatedResearch.state != ResearchState.Redeeming)
              updatedResearch
            else
              research,
        ],
      ),
    );
  }

  void addResearch({required Research research}) => state = AsyncValue.data(
        [...state.value ?? [], research],
      );

  Future<void> updateParticipantData(
    Participant participant,
  ) async {
    //get before to avoid overrides
    getEnrolledToResearchs(isRefreshing: true).then((_) {
      for (final research in state.value!) {
        if (research.isGroupResearch) {
          final groupResearch = research as GroupResearch;

          for (final group in groupResearch.groups) {
            for (final e in group.participants) {
              if (e.participant.participantId == participant.participantId) {
                // e.participant = participant;
                //TODO FIX
              }
            }
          }

          repository.updateDocument(groupResearch);
        } else {
          final singularResearch = research as SingularResearch;

          for (final e in singularResearch.enrollments) {
            if (e.participant.participantId == participant.participantId) {
              // e.participant = participant;
              //TODO FIX
            }
          }

          repository.updateDocument(singularResearch);
        }
      }
    });
  }

  void removeResearch(String researchId) {
    state = AsyncData(
      [
        for (final research in state.value!)
          if (research.researchId != researchId) research
      ],
    );
  }

  Future<void> removeParticipant(
      Research research, String participantId) async {
    research.removeParticipant(participantId);
    await updateResearch(updatedResearch: research);
    removeResearch(research.researchId!);
  }
}
