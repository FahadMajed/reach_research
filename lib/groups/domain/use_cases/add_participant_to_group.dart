import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/enrollments/domain/use_cases/enrollments.dart';
import 'package:reach_research/research.dart';

class AddParticipantToGroup extends UseCase<bool, AddParticipantToGroupParams> {
  AddParticipantToGroup({
    required this.groupsRepository,
    required this.chatsRepository,
  });

  @override
  Future<bool> call(AddParticipantToGroupParams params) async {
    _params = params;

    firstAvailableGroupId = await groupsRepository.getFirstAvailableGroupId(
      _researchId,
      _groupSize,
    );

    return _addParticipantToGroup().then(
      (groupId) async {
        if (params.groupResearch.researchState == ResearchState.ongoing) {
          await chatsRepository.addParticipantToGroupChat(
            groupId,
            _participant,
          );
        }

        //true if new group created, false otherwise
        return groupId != firstAvailableGroupId;
      },
    );
  }

  Future<String> _addParticipantToGroup() async {
    if (firstAvailableGroupId.isEmpty) {
      return await _addToNewGroup().then((group) => group.groupId);
    } else {
      await _addToAvailableGroup();
      return firstAvailableGroupId;
    }
  }

  Future<void> _addToAvailableGroup() async {
    final enrollment = Enrollment(
      participant: _participant,
      status: EnrollmentStatus.enrolled,
      redeemed: false,
      groupId: firstAvailableGroupId,
      benefits: const [],
    );

    return await groupsRepository.addEnrollmentToGroup(
      firstAvailableGroupId,
      enrollment,
    );
  }

  Future<Group> _addToNewGroup() async {
    final newGroupNumber = _groupsLength + 1;

    final groupId = _generateGroupId(number: newGroupNumber);

    final group = Group(
      researchId: _researchId,
      groupName: "Group $newGroupNumber",
      enrollments: [
        Enrollment(
            groupId: groupId,
            participant: _participant,
            status: EnrollmentStatus.enrolled,
            benefits: const [],
            redeemed: false)
      ],
      groupId: groupId,
    );

    return await groupsRepository.addGroup(group);
  }

  String _generateGroupId({required int number}) => Formatter.formatGroupId(
        number: number,
        title: _title,
      );

  //first group index is zero, but first group name is Group 1
  // so last group number will be its index + 1

  final GroupsRepository groupsRepository;
  final ChatsRepository chatsRepository;

  late AddParticipantToGroupParams _params;

  late String firstAvailableGroupId;

  Participant get _participant => _params.participant;
  int get _groupSize => _params.groupResearch.groupSize;
  int get _groupsLength => _params.groupResearch.groupsLength;
  String get _title => _params.groupResearch.title;
  String get _researchId => _params.groupResearch.researchId;
}

class AddParticipantToGroupParams extends AddParticipantParams {
  final GroupResearch groupResearch;

  AddParticipantToGroupParams({
    required super.participant,
    required this.groupResearch,
  });
}

final addParticipantToGroupPvdr =
    Provider<AddParticipantToGroup>((ref) => AddParticipantToGroup(
          chatsRepository: ref.read(chatsRepoPvdr),
          groupsRepository: ref.read(groupsRepoPvdr),
        ));
