import 'package:reach_auth/providers/providers.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final researchPvdr =
    StateNotifierProvider<ResearchNotifier, AsyncValue<Research?>>(
  (ref) {
    final read = ref.read;

    final uid = ref.watch(userIdPvdr);
    final isResearcher = ref.read(isResearcherPvdr);

    return ResearchNotifier(
      uid: uid,
      isResearcher: isResearcher,
      read: read,
    );
  },
);

//TODO GO TO RESEARCHER
final researchStatePvdr =
    StateNotifierProvider<ResearchStateNotifier, Research>(
  (ref) {
    final researcher = ref.watch(researcherPvdr).value!;
    return ResearchStateNotifier(
      researcher,
      Formatter.formatResearchId(
        researcher.researcherId,
      ),
    );
  },
);

final isResearcherPvdr = Provider((ref) => true);
