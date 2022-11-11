import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupsStateController extends AsyncListStateController<Group> {
  final Reader read;
  late final GetGroupsForResearch _getGroupsForResearch;

  GroupsStateController(this.read) {
    _getGroupsForResearch = read(getGroupsPvdr);
    getGroups();
  }

  Future<void> getGroups() async => await _getGroupsForResearch.call(_researchId).then(
        (groups) => emitData(groups),
        onError: (e) => emitError(e),
      );

  List<Enrollment> getEnrollmentsForGroup(Group g) => g.enrollments;

  List<Enrollment> getAllEnrollments() => [
        for (final g in groups) ...g.enrollments,
      ];

  int getParticipantGroupIndex(Participant participant) {
    return groups.indexOf(groups.firstWhere((group) => group.hasParticipant(participant)));
  }

  String get _researchId => read(researchStateCtrlPvdr).researchId;

  List<Group> get groups => state.value ?? [];
}
