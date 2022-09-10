import 'package:reach_chats/models/group_chat.dart';
import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ChangeParticipantGroup
    extends UseCase<List<Group>, ChangeParticipantGroupParams> {
  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;

  ChangeParticipantGroup({
    required this.groupsRepository,
    required this.chatsRepository,
  });

  @override
  Future<List<Group>> call(params) async {
    final from = params.from;
    final to = params.to;
    final participantIndex = params.participantIndexInGroup;

    final Enrollment participantToChange = from.enrollments[participantIndex];
    final partId = participantToChange.partId;

    await groupsRepository.removeEnrollmentFromGroup(
        from.groupId, participantToChange);
    await groupsRepository.addEnrollmentToGroup(
        to.groupId, participantToChange);

    await chatsRepository.changeParticipantGroupChat(
      params.groupChatFrom,
      params.groupChatTo,
      participantToChange.participant,
    );

    return [
      from.copyWith(
          enrollments: from.enrollments
            ..removeWhere((e) => e.partId == partId)),
      to.copyWith(enrollments: [...to.enrollments, participantToChange]),
    ];
  }
}

class ChangeParticipantGroupParams {
  final Group from;
  final Group to;
  final GroupChat? groupChatFrom;
  final GroupChat? groupChatTo;
  final int participantIndexInGroup;

  ChangeParticipantGroupParams({
    required this.from,
    required this.to,
    this.groupChatFrom,
    this.groupChatTo,
    required this.participantIndexInGroup,
  });
}

final changeParticipantGroupPvdr = Provider<ChangeParticipantGroup>((ref) =>
    ChangeParticipantGroup(
        groupsRepository: ref.read(groupsRepoPvdr),
        chatsRepository: ref.read(chatsRepoPvdr)));
