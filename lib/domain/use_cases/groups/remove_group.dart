import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveGroup extends UseCase<List<Group>, RemoveGroupParams> {
  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;
  final ParticipantsRepository participantsRepository;

  RemoveGroup({
    required this.groupsRepository,
    required this.chatsRepository,
    required this.participantsRepository,
  });

  RemoveGroupParams? _params;

  int get _toRemoveIndex => _params!.toRemoveIndex;
  List<Group> get _groups => _params!.groups;

  @override
  Future<List<Group>> call(RemoveGroupParams params) async {
    _params = params;
    final List<Group> groupsAfterRemove = [];

    if (_groups.length == 1) throw CannotDeleteAllGroups();

    final length = _groups.length;

    for (int i = 0; i < length; i++) {
      if (_toRemoveIndex > i) {
        //nothing to change
        groupsAfterRemove.add(_groups[i]);
      } else if (_toRemoveIndex == i) {
        //found
        for (final enrollment in _groups[i].enrollments) {
          await participantsRepository.removeEnrollment(
              enrollment.partId, _groups[i].researchId);
          await chatsRepository.removeResearchIdFromChat(
            Formatter.formatChatId(
              params.researcherId,
              enrollment.partId,
            ),
            _groups[i].researchId,
          );
        }
        await _removeGroup();
      } else if (_toRemoveIndex < i) {
        //we need to rename groups
        // i - 1 since length is reduced after removal
        //we will not enter to this scope until the group was removed
        final currentGroup = _groups[i - 1];
        final currentGroupId = currentGroup.groupId;

        groupsAfterRemove.add(currentGroup.copyWith(groupName: "Group $i"));
        await groupsRepository.updateGroupName(
          currentGroupId,
          "Group $i",
        );
        await chatsRepository.updateGroupName(
          currentGroupId,
          "Group $i",
        );
      }
    }
    return groupsAfterRemove;
  }

  Future<void> _removeGroup() async =>
      await groupsRepository.removeGroup(_groups[_toRemoveIndex]);
}

class RemoveGroupParams {
  final List<Group> groups;
  final int toRemoveIndex;
  final String researcherId;

  RemoveGroupParams({
    required this.groups,
    required this.toRemoveIndex,
    required this.researcherId,
  });
}
