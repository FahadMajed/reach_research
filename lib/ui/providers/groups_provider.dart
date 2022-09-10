import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final groupsPvdr =
    StateNotifierProvider<GroupsNotifier, AsyncValue<List<Group>>>(
  (ref) {
    final read = ref.read;
    final watch = ref.watch;
    final select = researchPvdr.select;

    final research = Research.empty().copyWith({
      'title': watch(select((rAsync) => rAsync.value!.title)),
      'researcher': watch(select((rAsync) => rAsync.value!.researcher)).toMap(),
      'researchId': watch(select((rAsync) => rAsync.value!.researchId)),
    });

    return GroupsNotifier(
      read: read,
      research: research,
    );
  },
);
