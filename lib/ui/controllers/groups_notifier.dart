import 'package:get/get.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupsNotifier extends StateNotifier<AsyncValue<List<Group>>>
    implements BaseGroup {
  final GroupResearch research;

  late final AddParticipantToGroup _addParticipantToGroup;

  late final AddEmptyGroup _addEmptyGroup;

  late final AddUniqueGroupBenefit _addUniqueBenefit;

  late final AddUnifiedGroupBeneftit _addUnifiedBenefit;

  late final ChangeParticipantGroup _changeParticipantGroup;

  late final RemoveGroup _removeGroup;

  late final KickParticipantFromGroup _kickParticipant;

  late final GetGroupsForResearch _getGroupsForResearch;

  GroupsNotifier({
    required this.research,
    required getGroupsForResearch,
    required addUniqueBenefit,
    required addEmptyGroup,
    required addUnifiedBenefit,
    required addParticipantToGroup,
    required changeParticipantGroup,
    required removeGroup,
    required kickParticipant,
  }) : super(const AsyncLoading()) {
    _getGroupsForResearch = getGroupsForResearch;
    _addUniqueBenefit = addUniqueBenefit;
    _addEmptyGroup = addEmptyGroup;
    _addUnifiedBenefit = addUnifiedBenefit;
    _addParticipantToGroup = addParticipantToGroup;
    _changeParticipantGroup = changeParticipantGroup;
    _removeGroup = removeGroup;
    _kickParticipant = kickParticipant;

    if (research.researchId.isNotEmpty) getGroups();
  }

  List<Group> get _groups => state.value ?? [];
  String get _researchId => research.researchId;
  String get _researchTitle => research.title;

  Future<void> getGroups() async {
    state = const AsyncLoading();

    await _getGroupsForResearch
        .call(GetGroupsForResearchParams(researchId: _researchId))
        .then(
          (groups) => state = AsyncData(groups),
          onError: (e) => state = AsyncError(e),
        );
  }

  // Future<void> addParticipant(Participant participant) async {
  //   groupsLoading();
  //   await _addParticipantToGroup
  //       .call(
  //         AddParticipantToGroupParams(
  //           participant: participant,
  //           groups: _groups,
  //           groupResearch: research,
  //         ),
  //       )
  //       .then(
  //           //if participant was added to existing group, update
  //           //otherwise add group to list
  //           (group) => groupExists(group.groupId)
  //               ? updateGroup(group)
  //               : addGroup(group),
  //           onError: (e) => groupsLoaded().then((_) => throw e));
  //   groupsLoaded();
  // }

  @override
  Future<void> addEmptyGroup() async {
    groupsLoading();
    await _addEmptyGroup
        .call(
          AddEmptyGroupParams(
            groupsLength: _groups.length,
            researchId: _researchId,
            researchTitle: _researchTitle,
          ),
        )
        .then(
          (group) => addGroup(group),
          onError: (e) => groupsLoaded().then((_) => throw e),
        );
    groupsLoaded();
  }

  @override
  Future<void> addUnifiedBenefit(Benefit benefit) async {
    groupsLoading();
    await _addUnifiedBenefit
        .call(AddUnifiedGroupBenefitParams(
          groups: _groups,
          benefit: benefit,
        ))
        .then(
          (groups) => state = AsyncData(groups),
          onError: (e) => groupsLoaded().then((_) => throw e),
        );
    groupsLoaded();
  }

  @override
  Future<void> addUniqueBenefit(
    Group group,
    Benefit benefit,
    Enrollment enrollment,
  ) async {
    groupsLoading();
    await _addUniqueBenefit
        .call(
          AddUniqueGroupBenefitsParams(
            benefit: benefit,
            enrollment: enrollment,
            group: group,
          ),
        )
        .then(
          (group) => updateGroup(group),
          onError: (e) => groupsLoaded().then((_) => throw e),
        );
    groupsLoaded();
  }

  @override
  Future<void> changeParticipantGroup(
      {required int participantIndex,
      required int fromIndex,
      required int toIndex}) async {
    groupsLoading();
    await _changeParticipantGroup
        .call(
          ChangeParticipantGroupParams(
              groups: _groups,
              fromIndex: fromIndex,
              toIndex: toIndex,
              participantIndex: participantIndex),
        )
        .then(
          (groups) => state = AsyncData(groups),
          onError: (e) => groupsLoaded().then((_) => throw e),
        );
    groupsLoaded();
  }

  @override
  Future<void> kickParticipant(Participant participant) async {
    groupsLoading();
    await _kickParticipant
        .call(KickParticipantFromGroupParams(
          participant: participant,
          groups: _groups,
          researcherId: research.researcher.researcherId,
        ))
        .then(
          (group) => updateGroup(group),
          onError: (e) => groupsLoaded().then((_) => throw e),
        );
    groupsLoaded();
  }

  @override
  Future<void> removeGroup(int groupIndex) async {
    groupsLoading();
    await _removeGroup
        .call(
          RemoveGroupParams(
            groups: _groups,
            toRemoveIndex: groupIndex,
            researcherId: research.researcher.researcherId,
          ),
        )
        .then(
          (groups) => state = AsyncData(groups),
          onError: (e) => groupsLoaded().then((_) => throw e),
        );

    groupsLoaded();
  }

  void updateGroup(Group group) {
    final groups = List<Group>.from(_groups);
    state = AsyncData(
      [
        for (final g in groups)
          if (g.groupId == group.groupId) group else g
      ],
    );
  }

  void addGroup(Group group) => state = AsyncData([..._groups, group]);

  bool groupExists(String groupId) {
    for (final group in _groups) {
      if (group.groupId == groupId) return true;
    }
    return false;
  }
}

final RxBool isGroupsLoading = false.obs;

void groupsLoading() => isGroupsLoading.value = true;
Future<void> groupsLoaded() async => isGroupsLoading.value = false;
