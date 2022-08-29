import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/use_cases/add_benefit/unified/add_uinified_benefit_group.dart';
import 'package:reach_research/research.dart';

class GroupsNotifier extends StateNotifier<AsyncValue<List<Group>>>
    implements BaseGroup {
  final GroupResearch research;

  @protected
  final AddParticipantToGroup addParticipantToGroupUseCase;
  @protected
  final AddEmptyGroup addEmptyGroupUseCase;
  @protected
  final AddUniqueGroupBenefit addUniqueBenefitUseCase;
  @protected
  final AddUnifiedGroupBeneftit addUnifiedBenefitUseCase;
  @protected
  final ChangeParticipantGroup changeParticipantGroupUseCase;
  @protected
  final RemoveGroup removeGroupUseCase;
  @protected
  final KickParticipantFromGroup kickParticipantUseCase;
  @protected
  final GetGroupsForResearch getGroupsForResearchUseCase;

  GroupsNotifier({
    required this.research,
    required this.getGroupsForResearchUseCase,
    required this.addUniqueBenefitUseCase,
    required this.addEmptyGroupUseCase,
    required this.addUnifiedBenefitUseCase,
    required this.addParticipantToGroupUseCase,
    required this.changeParticipantGroupUseCase,
    required this.removeGroupUseCase,
    required this.kickParticipantUseCase,
  }) : super(const AsyncLoading()) {
    if (research.researchId.isNotEmpty) getGroups();
  }

  List<Group> get _groups => state.value ?? [];
  String get _researchId => research.researchId;
  String get _researchTitle => research.title;

  Future<void> getGroups() async {
    state = const AsyncLoading();

    await getGroupsForResearchUseCase
        .call(GetGroupsForResearchParams(researchId: _researchId))
        .then(
          (groups) => state = AsyncData(groups),
          onError: (e) => state = AsyncError(e),
        );
  }

  Future<void> addParticipant(Participant participant) async =>
      await addParticipantToGroupUseCase
          .call(
            AddParticipantToGroupParams(
              participant: participant,
              groups: _groups,
              groupResearch: research,
            ),
          )
          .then(
              //if participant was added to existing group, update
              //otherwise add group to list
              (group) => groupExists(group.groupId)
                  ? updateGroup(group)
                  : addGroup(group),
              onError: (e) => state = AsyncError(e));

  @override
  Future<void> addEmptyGroup() async => await addEmptyGroupUseCase
      .call(
        AddEmptyGroupParams(
          groupsLength: _groups.length,
          researchId: _researchId,
          researchTitle: _researchTitle,
        ),
      )
      .then(
        (group) => addGroup(group),
        onError: (e) => state = AsyncError(e),
      );

  @override
  Future<void> addUnifiedBenefit(Benefit benefit) async =>
      await addUnifiedBenefitUseCase
          .call(AddUnifiedGroupBenefitParams(
            groups: _groups,
            benefit: benefit,
          ))
          .then(
            (groups) => state = AsyncData(groups),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> addUniqueBenefit(
    Group group,
    Benefit benefit,
    Enrollment enrollment,
  ) async =>
      await addUniqueBenefitUseCase
          .call(
            AddUniqueGroupBenefitsParams(
              benefit: benefit,
              enrollment: enrollment,
              group: group,
            ),
          )
          .then(
            (group) => updateGroup(group),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> changeParticipantGroup(
          {required int participantIndex,
          required int fromIndex,
          required int toIndex}) async =>
      await changeParticipantGroupUseCase
          .call(
            ChangeParticipantGroupParams(
                groups: _groups,
                fromIndex: fromIndex,
                toIndex: toIndex,
                participantIndex: participantIndex),
          )
          .then(
            (groups) => state = AsyncData(groups),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> kickParticipant(Participant participant) async =>
      await kickParticipantUseCase
          .call(KickParticipantFromGroupParams(
            participant: participant,
            groups: _groups,
            researcherId: research.researcher.researcherId,
          ))
          .then(
            (group) => updateGroup(group),
            onError: (e) => state = AsyncError(e),
          );

  @override
  Future<void> removeGroup(int groupIndex) async => await removeGroupUseCase
      .call(RemoveGroupParams(
        groups: _groups,
        toRemoveIndex: groupIndex,
        researcherId: research.researcher.researcherId,
      ))
      .then(
        (groups) => state = AsyncData(groups),
        onError: (e) => state = AsyncError(e),
      );

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
