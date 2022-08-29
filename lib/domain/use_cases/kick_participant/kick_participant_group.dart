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
    final _groups = params.groups;
    final partId = params.participant.participantId;

    int participantIndex = -1;
    int participantGroupIndex = -1;
    for (final group in _groups) {
      participantIndex = group.getParticipantIndex(partId);
      if (participantIndex != -1) {
        participantGroupIndex = _groups.indexOf(group);
        break;
      }
    }

    final updatedGroup = _groups[participantGroupIndex]
      ..enrollments.removeAt(participantIndex);

    await participantsRepository.removeCurrentEnrollment(
      partId,
      updatedGroup.researchId,
    );

    await chatsRepository.removeResearchIdFromChat(
      Formatter.formatChatId(
        params.researcherId,
        partId,
      ),
      updatedGroup.researchId,
    );

    await chatsRepository.removeParticipantFromGroupChat(
      updatedGroup.groupId,
      params.participant,
    );

    return await groupsRepository
        .updateGroup(updatedGroup)
        .then((_) => updatedGroup);
  }
}

class KickParticipantFromGroupParams {
  final Participant participant;
  final List<Group> groups;
  final String researcherId;

  KickParticipantFromGroupParams({
    required this.participant,
    required this.groups,
    required this.researcherId,
  });
}
