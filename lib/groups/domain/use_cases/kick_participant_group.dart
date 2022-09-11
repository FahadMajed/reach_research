import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class KickParticipantFromGroup
    extends UseCase<Group, KickParticipantFromGroupParams> {
  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;
  final ParticipantsRepository participantsRepository;

  KickParticipantFromGroup({
    required this.groupsRepository,
    required this.chatsRepository,
    required this.participantsRepository,
  });

  @override
  Future<Group> call(KickParticipantFromGroupParams params) async {
    final _group = params.group;

    final partId = params.participantId;

    final updatedGroup = _group.removeEnrollment(partId);

    participantsRepository.removeEnrollment(
      partId,
      updatedGroup.researchId,
    );

    chatsRepository.removeResearchIdFromChat(
      Formatter.formatChatId(
        params.researcherId,
        partId,
      ),
      updatedGroup.researchId,
    );

    chatsRepository.removeParticipantFromGroupChat(
      updatedGroup.groupId,
      partId,
    );

    return await groupsRepository
        .updateGroup(updatedGroup)
        .then((_) => updatedGroup);
  }
}

class KickParticipantFromGroupParams {
  final String participantId;
  final Group group;
  final String researcherId;

  KickParticipantFromGroupParams({
    required this.participantId,
    required this.group,
    required this.researcherId,
  });
}

final kickParticipantFromGroupPvdr =
    Provider<KickParticipantFromGroup>((ref) => KickParticipantFromGroup(
          chatsRepository: ref.read(chatsRepoPvdr),
          groupsRepository: ref.read(groupsRepoPvdr),
          participantsRepository: ref.read(partsRepoPvdr),
        ));
