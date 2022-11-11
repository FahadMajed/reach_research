import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveGroup extends UseCase<List<Group>, RemoveGroupRequest> {
  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;
  final ParticipantsRepository participantsRepository;
  final ResearchsRepository researchsRepository;
  final RemoveParticipants removeParticipants;
  RemoveGroup({
    required this.groupsRepository,
    required this.chatsRepository,
    required this.participantsRepository,
    required this.researchsRepository,
    required this.removeParticipants,
  });

  late RemoveGroupRequest _request;

  int get _toRemoveIndex => _request.toRemoveIndex;
  List<Group> get _groups => _request.groups;
  Research get _research => _request.research;

  String? get _researchTitle => _research.title;

  @override
  Future<List<Group>> call(RemoveGroupRequest request) async {
    _request = request;
    final List<Group> groupsAfterRemove = [];

    List participantsToRemoveIds = _groups[_toRemoveIndex].enrollmentsIds;

    if (_groups.length == 1) throw CannotDeleteAllGroups();

    final length = _groups.length;

    for (int currentGroupIndex = 0; currentGroupIndex < length; currentGroupIndex++) {
      if (_currentGroupIsBeforeRemovedGroup(currentGroupIndex)) {
        //nothing to change
        groupsAfterRemove.add(_groups[currentGroupIndex]);
      } else if (_toRemoveIndex == currentGroupIndex) {
        _removeResearchFromParticipantEnrollments(currentGroupIndex);

        _removeParticipantsChatsFromResearch(currentGroupIndex);

        _removeGroup();
      } else if (_currentGroupIsAfterRemovedGroup(currentGroupIndex)) {
        //we need to rename groups
        //Groups are named according to thier order
        final updatedGroup = _decrementGroupName(currentGroupIndex);

        groupsAfterRemove.add(updatedGroup);
      }
    }

    removeParticipants.call(RemoveParticipantsRequest(
      research: _research,
      toRemoveIds: participantsToRemoveIds,
    ));

    return groupsAfterRemove;
  }

  bool _currentGroupIsBeforeRemovedGroup(int currentGroupIndex) => _toRemoveIndex > currentGroupIndex;

  void _removeResearchFromParticipantEnrollments(int currentGroupIndex) {
    for (final enrollment in _groups[currentGroupIndex].enrollments) {
      participantsRepository.removeEnrollment(
        enrollment.partId,
        _groups[currentGroupIndex].researchId,
      );
    }
  }

  void _removeParticipantsChatsFromResearch(int removedGroupIndex) {
    for (final participantId in _groups[removedGroupIndex].enrollmentsIds) {
      chatsRepository.removeResearchIdFromPeerChat(
        Formatter.formatChatId(
          _research.researcherId,
          participantId,
        ),
        _groups[removedGroupIndex].researchId,
      );
    }
    chatsRepository.removeGroup(_groups[removedGroupIndex].groupId);
  }

  Future<void> _removeGroup() async => await groupsRepository.removeGroup(_groups[_toRemoveIndex]);

  bool _currentGroupIsAfterRemovedGroup(int currentGroupIndex) => _toRemoveIndex < currentGroupIndex;

  ///currentGroupIndex, e.g. 2, while this group index was
  ///3, so it must be decremented to 2.
  Group _decrementGroupName(int currentGroupIndex) {
    final currentGroup = _groups[currentGroupIndex];
    final currentGroupId = currentGroup.groupId;

    final newName = "Group $currentGroupIndex";
    final newNameWithTitle = newName + " - $_researchTitle";

    groupsRepository.updateGroupNumber(
      currentGroupId,
      currentGroupIndex,
    );

    chatsRepository.updateGroupName(
      currentGroupId,
      newNameWithTitle,
    );

    return currentGroup.copyWith(
      groupNumber: currentGroupIndex,
    );
  }
}

class RemoveGroupRequest {
  final List<Group> groups;
  final int toRemoveIndex;
  final Research research;

  RemoveGroupRequest({required this.groups, required this.toRemoveIndex, required this.research});
}

final removeGroupPvdr = Provider<RemoveGroup>((ref) => RemoveGroup(
      chatsRepository: ref.read(chatsRepoPvdr),
      groupsRepository: ref.read(groupsRepoPvdr),
      participantsRepository: ref.read(partsRepoPvdr),
      researchsRepository: ref.read(researchsRepoPvdr),
      removeParticipants: ref.read(removeParticipantsPvdr),
    ));
