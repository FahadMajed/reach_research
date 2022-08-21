import 'package:reach_auth/providers/providers.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrolledListNotifier extends StateNotifier<AsyncValue<List<Research>>> {
  final String _uid;
  final ResearchsRepository _repository;

  EnrolledListNotifier(this._uid, this._repository)
      : super(const AsyncValue.loading()) {
    if (_uid.isNotEmpty) {
      getEnrolledToResearchs();
    } else {
      const AsyncData([]);
    }
  }

  List<Research> get researchs => state.value ?? [];

  Future<void> getEnrolledToResearchs({isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    final researchs = await _repository.getEnrolledToResearchs(_uid);
    if (mounted) state = AsyncValue.data(researchs);
  }

  Future<void> _updateField(
          String researchId, String fieldName, dynamic fieldData) async =>
      await _repository.updateField(researchId, fieldName, fieldData);

  Future<void> updateResearch({required Research updatedResearch}) async {
    // await repository.upda(updatedResearch);

    state = AsyncValue.data(
      [
        for (final research in researchs)
          if (research.researchId == updatedResearch.researchId)
            updatedResearch
          else
            research,
      ],
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
          groupResearch.updateParticipant(participant);
          _updateField(
            groupResearch.researchId,
            'groups',
            groupResearch.groups.map((e) => e.toMap()),
          );
        } else {
          final singularResearch = research as SingularResearch;

          singularResearch.updateParticipant(participant);

          _repository.updateData(singularResearch, singularResearch.researchId);
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
    removeResearch(research.researchId);
  }
}

final enrolledPvdr =
    StateNotifierProvider<EnrolledListNotifier, AsyncValue<List<Research>>>(
  (ref) {
    final userId = ref.watch(userPvdr).value?.uid;

    return EnrolledListNotifier(userId ?? "", ref.watch(researchsRepoPvdr));
  },
);
