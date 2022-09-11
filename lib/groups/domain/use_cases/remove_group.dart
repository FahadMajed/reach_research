import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveGroup extends UseCase<List<Group>, RemoveGroupParams> {
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

  RemoveGroupParams? _params;

  int get _toRemoveIndex => _params!.toRemoveIndex;
  List<Group> get _groups => _params!.groups;

  @override
  Future<List<Group>> call(RemoveGroupParams params) async {
    _params = params;
    final List<Group> groupsAfterRemove = [];

    List participantsToRemoveIds = _groups[_toRemoveIndex].enrollmentsIds;

    if (_groups.length == 1) throw CannotDeleteAllGroups();

    final length = _groups.length;

    for (int i = 0; i < length; i++) {
      if (_toRemoveIndex > i) {
        //nothing to change
        groupsAfterRemove.add(_groups[i]);
      } else if (_toRemoveIndex == i) {
        //found

        for (final enrollment in _groups[i].enrollments) {
          participantsRepository.removeEnrollment(
            enrollment.partId,
            _groups[i].researchId,
          );
        }
        for (final chatId in params.chatsIds ?? []) {
          chatsRepository.removeResearchIdFromChat(
            chatId,
            _groups[i].researchId,
          );
        }
        chatsRepository.removeGroup(_groups[i].groupId);

        await _removeGroup();
      } else if (_toRemoveIndex < i) {
        //we need to rename groups
        // i - 1 since length is reduced after removal
        //we will not enter to this scope until the group was removed

        final currentGroup = _groups[i];
        final currentGroupId = currentGroup.groupId;

        groupsAfterRemove.add(currentGroup.copyWith(groupName: "Group $i"));
        await groupsRepository.updateGroupName(
          currentGroupId,
          "Group $i",
        );
        await chatsRepository.updateGroupName(
          currentGroupId,
          "Group $i - ${params.researchTitle}",
        );
      }
    }

    await removeParticipants.call(RemoveParticipantsParams(
      researchId: _groups.first.researchId,
      toRemoveIds: participantsToRemoveIds,
    ));

    return groupsAfterRemove;
  }

  Future<void> _removeGroup() async =>
      await groupsRepository.removeGroup(_groups[_toRemoveIndex]);

  String get researchId => _groups.first.researchId;
}

class RemoveGroupParams {
  final List<Group> groups;
  final int toRemoveIndex;
  //for updataing chat name
  final String? researchTitle;
  final List? chatsIds;

  RemoveGroupParams({
    required this.groups,
    required this.toRemoveIndex,
    this.researchTitle,
    this.chatsIds,
  });
}

final removeGroupPvdr = Provider<RemoveGroup>((ref) => RemoveGroup(
      chatsRepository: ref.read(chatsRepoPvdr),
      groupsRepository: ref.read(groupsRepoPvdr),
      participantsRepository: ref.read(partsRepoPvdr),
      researchsRepository: ref.read(researchsRepoPvdr),
      removeParticipants: ref.read(removeParticipantsPvdr),
    ));
