import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ChangeParticipantGroup extends UseCase<ChangeParticipantGroupResponse, ChangeParticipantGroupRequest> {
  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;

  ChangeParticipantGroup({
    required this.groupsRepository,
    required this.chatsRepository,
  });
  late ChangeParticipantGroupRequest _request;
  Group get _from => _request.from;
  Group get _to => _request.to;

  int get _participantIndexInGroup => _from.getParticipantIndex(_participantId);
  String get _participantId => _request.participantId;

  Enrollment get _enrollmentToChange => _from.enrollments[_participantIndexInGroup];

  @override
  Future<ChangeParticipantGroupResponse> call(request) async {
    _request = request;

    final from = _from.removeEnrollment(_participantId);
    final to = _to.addEnrollment(_enrollmentToChange.copyWith(
      groupId: _to.groupId,
    ));

    groupsRepository.updateGroup(from);
    groupsRepository.updateGroup(to);

    chatsRepository.changeParticipantGroupChat(
      request.groupChatFrom,
      request.groupChatTo,
      _enrollmentToChange.participant,
    );

    return ChangeParticipantGroupResponse(
      from: from,
      to: to,
    );
  }
}

class ChangeParticipantGroupRequest {
  final Group from;
  final Group to;
  final GroupChat? groupChatFrom;
  final GroupChat? groupChatTo;
  final String participantId;

  ChangeParticipantGroupRequest({
    required this.from,
    required this.to,
    this.groupChatFrom,
    this.groupChatTo,
    required this.participantId,
  });
}

class ChangeParticipantGroupResponse {
  final Group from;
  final Group to;
  ChangeParticipantGroupResponse({
    required this.from,
    required this.to,
  });
}

final changeParticipantGroupPvdr = Provider<ChangeParticipantGroup>((ref) =>
    ChangeParticipantGroup(groupsRepository: ref.read(groupsRepoPvdr), chatsRepository: ref.read(chatsRepoPvdr)));
