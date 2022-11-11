import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final researchStatePvdr = StateNotifierProvider<ResearchStateController, AsyncValue<Research?>>(
  (ref) => ResearchStateController(),
);

final researchStateCtrlPvdr = Provider<ResearchStateController>((ref) => ref.watch(researchStatePvdr.notifier));

final isResearcherPvdr = Provider((ref) => true);

final researchIdPvdr = Provider((ref) => ref.watch(researchStatePvdr).value?.researchId ?? "");
