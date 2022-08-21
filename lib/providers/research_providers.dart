import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final currentResearchIdPvdr = StateProvider<String>(
  (ref) => "",
);

final enrollmentsPvdr = Provider<List<EnrolledTo>>((ref) {
  final research = ref.watch(researchPvdr);

  return research is SingularResearch
      ? research.enrollments
      : [
          for (final group in (research as GroupResearch).groups)
            for (final e in group.enrollments) e
        ];
});
