import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupsNotifier extends StateNotifier<AsyncValue<List<Group>>>
    implements BaseGroup {
  void set(List<Group> groups) => state = AsyncData(groups);

  final Research research;
  final Reader read;

  late final AddParticipantToGroup _addParticipantToGroup;

  late final AddEmptyGroup _addEmptyGroup;

  late final AddUniqueGroupBenefit _addUniqueBenefit;

  late final AddUnifiedGroupBenefit _addUnifiedBenefit;

  late final ChangeParticipantGroup _changeParticipantGroup;

  late final RemoveGroup _removeGroup;

  late final KickParticipantFromGroup _kickParticipant;

  late final GetGroupsForResearch _getGroupsForResearch;

  GroupsNotifier({
    required this.read,
    required this.research,
  }) : super(const AsyncLoading()) {
    _getGroupsForResearch = read(getGroupsPvdr);
    _addUniqueBenefit = read(addUniqueGroupBenefitPvdr);
    _addEmptyGroup = read(addEmptyGroupPvdr);
    _addUnifiedBenefit = read(addUnifiedGroupBenefitPvdr);
    _addParticipantToGroup = read(addParticipantToGroupPvdr);
    _changeParticipantGroup = read(changeParticipantGroupPvdr);
    _removeGroup = read(removeGroupPvdr);
    _kickParticipant = read(kickParticipantFromGroupPvdr);

    if (research.researchId.isNotEmpty) getGroups();
  }

  List<Group> get _groups => state.value ?? [];
  String get _researchId => research.researchId;
  String get _researchTitle => research.title;

  ResearchNotifier get researchNotifier => read(researchPvdr.notifier);
  ChatsListNotifier get chatsNotifier => read(chatsPvdr.notifier);

  Future<void> getGroups() async {
    state = const AsyncLoading();

    await _getGroupsForResearch
        .call(GetGroupsForResearchParams(researchId: _researchId))
        .then(
          (groups) => state = AsyncData(groups),
          onError: (e) => state = AsyncError(e),
        );
  }

  Future<void> addParticipant(Participant participant) async {
    groupsLoading();
    // await _addParticipantToGroup
    //     .call(
    //       AddParticipantToGroupParams(
    //         participant: participant,
    //         groupResearch: research,
    //       ),
    //     )
    //     .then(
    //         //if participant was added to existing group, update
    //         //otherwise add group to list
    //         (group) => groupExists(group.groupId)
    //             ? updateGroup(group)
    //             : addGroup(group),
    //         onError: (e) => onGroupError(e));
    groupsLoaded();
  }

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
  Future<void> changeParticipantGroup({
    required int participantIndex,
    required int fromIndex,
    required int toIndex,
    GroupChat? groupChatFrom,
    GroupChat? groupChatTo,
  }) async {
    groupsLoading();
    await _changeParticipantGroup
        .call(
          ChangeParticipantGroupParams(
            from: _groups[fromIndex],
            to: _groups[toIndex],
            participantIndexInGroup: participantIndex,
            groupChatFrom: groupChatFrom,
            groupChatTo: groupChatTo,
          ),
        )
        .then(
          (groups) => this
            ..updateGroup(groups.first)
            ..updateGroup(groups.last),
          onError: (e) => onGroupError(e),
        );
    groupsLoaded();
  }

  @override
  Future<void> kickParticipant(
    int groupIndex,
    Participant participant,
  ) async {
    groupsLoading();
    await _kickParticipant
        .call(KickParticipantFromGroupParams(
          participantId: participant.participantId,
          group: _groups[groupIndex],
          researcherId: research.researcher.researcherId,
        ))
        .then(
          (group) => updateGroup(group),
          onError: (e) => onGroupError(e),
        );

    groupsLoaded();
  }

  @override
  Future<void> removeGroup(int groupIndex) async {
    groupsLoading();

    final chatsIds =
        chatsNotifier.getPeerChatIdsForResearch(_groups[groupIndex].researchId);

    return await _removeGroup
        .call(
      RemoveGroupParams(
        groups: _groups,
        toRemoveIndex: groupIndex,
        researchTitle: _researchTitle,
        chatsIds: chatsIds,
      ),
    )
        .then(
      (groups) {
        groupsLoaded();

        researchNotifier.getResearch();
        state = AsyncData(groups);
      },
      onError: (e) => onGroupError(e),
    );
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

  void onGroupError(e) {
    groupsLoaded();
    throw e;
  }
}

final RxBool isGroupsLoading = false.obs;

void groupsLoading() => isGroupsLoading.value = true;
Future<void> groupsLoaded() async => isGroupsLoading.value = false;
