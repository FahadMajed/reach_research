// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:reach_auth/providers/providers.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final researchsPvdr =
    StateNotifierProvider<ResearchListNotifier, AsyncValue<List<Research>>>(
  (ref) {
    final userId = ref.watch(userPvdr).value?.uid ?? "";

    return ResearchListNotifier(
      userId,
      ref.read(
        researchsRepoPvdr,
      ),
    );
  },
);

class ResearchListNotifier extends StateNotifier<AsyncValue<List<Research>>> {
  final String uid;
  final ResearchsRepository repository;

  ResearchListNotifier(
    this.uid,
    this.repository,
  ) : super(const AsyncValue.loading()) {
    if (uid.isNotEmpty) {
      getAllResearchs();
    } else {
      const AsyncData([]);
    }
  }

  Future<List<Research>> getAllResearchs({isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();

    final researchs = await repository.getDocuments(uid);

    if (mounted) state = AsyncValue.data(researchs);
    return state.value!;
  }

  // void retainWhereMatched(
  //   bool Function(Map<String, Criterion> criteria) isMatched,
  // ) {
  //   if (state.value != null) {
  //     state.value!.retainWhere((research) => isMatched(research.criteria));
  //   }
  // }

  Research getResearch(String researchId) =>
      state.value!.firstWhere((e) => e.researchId == researchId);

  Research? getResearchById(String id) => state
      .whenData((researchs) => researchs.firstWhere((r) => r.researchId == id))
      .value;

  Future<bool> addResearch({required Research research}) async {
    await repository.createDocument(research);

    state = AsyncValue.data(state.value!..add(copyResearchWith(research)));

    return true;
  }

  Future<void> updateResearcher({required Researcher researcher}) async {
    List<Research> researchsState = [];
    await getAllResearchs().then(
      (researchs) {
        for (final research in researchs) {
          repository.updateField(
            research.researchId,
            "researcher",
            researcher,
          );
          researchsState.add(copyResearchWith(
            research,
            researcher: researcher,
          ));
        }
      },
    );
    state = AsyncData(researchsState);
  }

  void clear() {
    final researchs = state.value;
    for (final research in researchs!) {
      repository.deleteDocument(research.researchId);
    }
    state = const AsyncData([]);
  }

  void updateResearchState(Research ongoingResearch) {
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
