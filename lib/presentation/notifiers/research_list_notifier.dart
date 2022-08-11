import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchListNotifier extends StateNotifier<AsyncValue<List<Research>>> {
  final String uid;
  late final ResearchsRepository repository;
  late final Reader read;
  ResearchListNotifier(
    this.read,
    this.uid,
  ) : super(const AsyncValue.loading()) {
    repository = read(researchsRepoPvdr);
    if (uid.isNotEmpty) {
      getAllResearchs();
    }
  }

  Future<void> getAllResearchs({isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    final researchs = await repository.getDocuments(uid);

    if (mounted) state = AsyncValue.data(researchs);
  }

  Future<void> updateResearch({required Research updatedResearch}) async {
    await repository.updateDocument(updatedResearch);

    if (mounted) {
      state.whenData(
        (researchs) => state = AsyncValue.data(
          [
            for (final research in researchs)
              if (research.researchId == updatedResearch.researchId)
                updatedResearch
              else
                research,
          ],
        ),
      );
    }
  }

  void retainWhereMatched(Participant participant) {
    if (state.value != null) {
      state.value!
          .retainWhere((research) => participant.isMatched(research.criteria));
    }
  }

  Research getResearch(String researchId) =>
      state.value!.firstWhere((e) => e.researchId == researchId);

  addParticipant(
      {required Research research, required Participant participant}) {}

  rejectParticipant(
      {required Research research, required String participantId}) {}

  Research? getResearchById(String id) => state
      .whenData((researchs) => researchs.firstWhere((r) => r.researchId == id))
      .value;

  Future<String> addResearch({required Research research}) async {
    final researchId =
        await repository.createDocument(research).then((r) => r.researchId);

    state.whenData((researchs) => state = AsyncValue.data(
        researchs..add(copyResearchWith(research, researchId: researchId))));

    return researchId ?? "";
  }

  Future<void> updateResearcher({required Researcher researcher}) async {
    getAllResearchs().then(
      (value) {
        final researchs = state.value;

        for (final research in researchs!) {
          repository.updateField(
              research.researchId!, "researcher", researcher);
        }
      },
    );
  }

  Future<void> requestMoreParticipants(
      Research research, int requestedParticipantsNumber) async {
    await updateResearch(
      updatedResearch: copyResearchWith(research,
          requestedParticipantsNumber: requestedParticipantsNumber,
          requestJoiners: 0,
          isRequestingParticipants: true),
    );
  }

  void clear() {
    final researchs = state.value;
    for (final research in researchs!) {
      repository.deleteDocument(research.researchId!);
    }
    state.value!.clear();
  }

  void updateResearchState() {
    final ongoingResearch = read(ongoingResearchPvdr);
    state = AsyncValue.data(
      [
        for (final research in state.value ?? [])
          if (research.researchId == ongoingResearch.researchId)
            ongoingResearch
          else
            research,
      ]..retainWhere((r) => r.state != ResearchState.Redeeming),
    );
  }
}
