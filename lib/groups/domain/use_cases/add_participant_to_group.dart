import 'package:reach_chats/data/data.dart';
import 'package:reach_chats/domain/contracts/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddParticipantToGroup extends UseCase<void, AddParticipantToGroupRequest> {
  AddParticipantToGroup({
    required this.groupsRepository,
    required this.chatsRepository,
  });

  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;

  late AddParticipantToGroupRequest _request;

  Participant get _participant => _request.participant;
  int get _groupSize => _research.groupSize;
  String get _title => _research.title;
  String get _researchId => _research.researchId;
  bool get noAvailableGroup => availableGroupId.isEmpty;

  late GroupResearch _research;
  late String availableGroupId;

  @override
  Future<void> call(AddParticipantToGroupRequest request) async {
    _request = request;
    _research = request.groupResearch;

    availableGroupId = await groupsRepository.getAvailableGroupId(
      _researchId,
      _groupSize,
    );

    await _addParticipantToResearchGroup().then(
      (groupId) async {
        _addParticipantToGroupChat(
          request,
          groupId,
        );
      },
    );
  }

  Future<String> _addParticipantToResearchGroup() async {
    if (noAvailableGroup) {
      return await _addToNewGroup().then((groupId) => groupId);
    } else {
      await _addToAvailableGroup();
      return availableGroupId;
    }
  }

  Future<void> _addToAvailableGroup() async {
    final enrollment = Enrollment.create(
      _participant,
      groupId: availableGroupId,
      researchId: _researchId,
    );

    return await groupsRepository.addEnrollmentToGroup(
      availableGroupId,
      enrollment,
    );
  }

  Future<String> _addToNewGroup() async {
    final newGroupNumber = await _getGroupsLength() + 1;

    final groupId = _generateGroupId(number: newGroupNumber);

    final group = Group(
      enrollmentsIds: [_participant.participantId],
      researchId: _researchId,
      groupNumber: newGroupNumber,
      enrollments: [
        Enrollment.create(
          _participant,
          groupId: groupId,
        )
      ],
      groupId: groupId,
    );
    groupsRepository.addGroup(group);
    return groupId;
  }

  Future<int> _getGroupsLength() async {
    return await groupsRepository.getGroupsCountForResearch(_researchId);
  }

  String _generateGroupId({required int number}) => Formatter.formatGroupId(
        number: number,
        title: _title,
      );

  Future<void> _addParticipantToGroupChat(
    AddParticipantToGroupRequest request,
    String groupId,
  ) async {
    if (_research.isOngoing) {
      chatsRepository.addParticipantToGroupChat(
        groupId,
        _participant,
      );
    }
  }
}

class AddParticipantToGroupRequest extends AddEnrollmentRequest {
  final GroupResearch groupResearch;

  AddParticipantToGroupRequest({
    required super.participant,
    required this.groupResearch,
  });
}

final addParticipantToGroupPvdr = Provider<AddParticipantToGroup>((ref) => AddParticipantToGroup(
      chatsRepository: ref.read(chatsRepoPvdr),
      groupsRepository: ref.read(groupsRepoPvdr),
    ));
