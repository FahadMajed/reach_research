import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class KickParticipantFromGroup extends UseCase<Group, KickParticipantFromGroupRequest> {
  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;

  KickParticipantFromGroup({
    required this.groupsRepository,
    required this.chatsRepository,
  });

  @override
  Future<Group> call(KickParticipantFromGroupRequest request) async {
    final _group = request.group;

    final partId = request.participantId;

    final updatedGroup = _group.removeEnrollment(partId);

    chatsRepository.removeParticipantFromGroupChat(
      updatedGroup.groupId,
      partId,
    );

    groupsRepository.updateGroup(updatedGroup);

    return updatedGroup;
  }
}

class KickParticipantFromGroupRequest {
  final String participantId;
  final Group group;

  KickParticipantFromGroupRequest({
    required this.participantId,
    required this.group,
  });
}

final kickParticipantFromGroupPvdr = Provider<KickParticipantFromGroup>((ref) => KickParticipantFromGroup(
      chatsRepository: ref.read(chatsRepoPvdr),
      groupsRepository: ref.read(groupsRepoPvdr),
    ));
