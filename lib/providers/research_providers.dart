import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final currentResearchIdPvdr = StateProvider<String>(
  (ref) => "",
);

// final researchPvdr = StateProvider<Research>((ref) {
//   final researchId = ref.watch(currentResearchIdPvdr);
//   if (researchId.isNotEmpty) {
//     return ref.watch(researchListAsyncPvdr.notifier).getResearch(researchId);
//   } else {
//     return Research.fromFirestore({});
//   }
// });

final researchPvdr = StateNotifierProvider<ResearchNotifier, Research>(
    (ref) => ResearchNotifier());

final currentResearchPvdr =
    StateProvider((ref) => Research(researcher: ref.watch(researcherPvdr)));

final enrollmentsPvdr = Provider<List<EnrolledTo>>((ref) {
  final research = ref.watch(ongoingResearchPvdr);

  return research is SingularResearch
      ? research.enrollments
      : [
          for (final group in (research as GroupResearch).groups)
            for (final e in group.participants) e
        ];
});

final researchsPvdr =
    StateNotifierProvider<ResearchListNotifier, AsyncValue<List<Research>>>(
  (ref) {
    final userId = ref.watch(userPvdr).value?.uid ?? "";

    return ResearchListNotifier(ref.read, userId);
  },
);

final ongoingResearchPvdr =
    StateNotifierProvider<OngoingResearchNotifier, Research>((ref) =>
        OngoingResearchNotifier(ref.read, ref.watch(currentResearchPvdr)));

final enrolledPvdr =
    StateNotifierProvider<EnrolledListNotifier, AsyncValue<List<Research>>>(
  (ref) {
    final userId = ref.watch(userPvdr).value?.uid;

    return EnrolledListNotifier(userId ?? "", ref.watch(researchsRepoPvdr));
  },
);
