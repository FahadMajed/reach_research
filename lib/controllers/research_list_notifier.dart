import 'package:reach_auth/providers/providers.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchListNotifier extends StateNotifier<AsyncValue<List<Research>>> {
  final String _uid;
  final bool _isResearcher;
  final ResearchsRepository _repository;

  ResearchListNotifier(
    this._isResearcher,
    this._uid,
    this._repository,
  ) : super(const AsyncValue.loading()) {
    if (_uid.isNotEmpty) {
      getResearchs();
    } else {
      const AsyncData([]);
    }
  }

  List<Research> get researchs => state.value ?? [];

  Future<List<Research>> getResearchs({isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();

    List<Research> researchs = [];

    researchs = await _repository.getResearchs(_isResearcher);

    if (mounted) state = AsyncValue.data(researchs);
    return researchs;
  }

  Future<void> _updateField(
          String researchId, String fieldName, dynamic fieldData) async =>
      await _repository.updateField(researchId, fieldName, fieldData);

  // void retainWhereMatched(
  //   bool Function(Map<String, Criterion> criteria) isMatched,
  // ) {
  //   if (state.value != null) {
  //     researchs.retainWhere((research) => isMatched(research.criteria));
  //   }
  // }

  Research getResearch(String researchId) =>
      researchs.firstWhere((e) => e.researchId == researchId);

  Research? getResearchById(String id) => state
      .whenData((researchs) => researchs.firstWhere((r) => r.researchId == id))
      .value;

  Future<bool> addResearch({required Research research}) async {
    await _repository.create(research, research.researchId);

    state = AsyncValue.data(researchs..add(copyResearchWith(research)));

    return true;
  }

  Future<void> updateResearcher({required Researcher researcher}) async {
    for (final research in researchs) {
      _repository.updateResearcher(
        research.researchId,
        researcher,
      );
      updateResearch(copyResearchWith(research, researcher: researcher));
    }
  }

  void clear() {
    final researchs = state.value;
    for (final research in researchs!) {
      _repository.delete(research.researchId);
    }
    state = const AsyncData([]);
  }

  void updateResearch(Research ongoingResearch) {
    state = AsyncValue.data(
      [
        for (final research in state.value ?? [])
          if (research.researchId == ongoingResearch.researchId)
            ongoingResearch
          else
            research,
      ]..retainWhere((r) => r.researchState != ResearchState.redeeming),
    );
  }
}

final researchsPvdr =
    StateNotifierProvider<ResearchListNotifier, AsyncValue<List<Research>>>(
  (ref) {
    final userId = ref.watch(userPvdr).value?.uid ?? "";

    return ResearchListNotifier(
      ref.read(isResearcher),
      userId,
      ref.read(
        researchsRepoPvdr,
      ),
    );
  },
);

final isResearcher = Provider((ref) => true);
