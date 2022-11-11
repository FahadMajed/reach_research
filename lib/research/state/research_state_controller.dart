import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchStateController extends AsyncStateControIIer<Research?> {
  Research get research => state.value ?? Research.empty();
  String get researchId => research.researchId;
  bool get isGroupResearch => research.isGroupResearch;

  set meetings(List<Meeting> meetings) => state = AsyncData(copyResearchWith(research, meetings: meetings));

  set phases(List<Phase> phases) => state = AsyncData(copyResearchWith(research, phases: phases));

  void removeMeeting(Meeting meeting) => state = AsyncData(research.removeMeeting(meeting));
}
