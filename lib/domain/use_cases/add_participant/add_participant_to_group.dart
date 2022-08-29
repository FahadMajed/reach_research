import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

//TODO Add to group chat if exists
class AddParticipantToGroup
    extends UseCase<Group, AddParticipantToGroupParams> {
  AddParticipantToGroup(this.repository);

  final GroupsRepository repository;

  AddParticipantToGroupParams? _params;

  List<Group> get _groups => _params!.groups;

  Participant get _participant => _params!.participant;
  int get _groupSize => _params!.groupResearch.groupSize;
  String get _title => _params!.groupResearch.title;
  String get _researchId => _params!.groupResearch.researchId;
  int get _lastGroupNumber => _groups.indexOf(_groups.last) + 1;

  @override
  Future<Group> call(AddParticipantToGroupParams params) {
    _params = params;

    return _addParticipantToGroup();
  }

  Future<Group> _addParticipantToGroup() async {
    if (_groups.isEmpty) {
      return await _addFirstGroup();
    } else {
      if (_allGroupsAreFull()) {
        return await _addToNewGroup();
      } else {
        return await _addToAvailableGroup();
      }
    }
  }

  Future<Group> _addFirstGroup() async {
    final groupId = _generateGroupId(number: 1);

    final group1 = Group(
      researchId: _researchId,
      groupId: groupId,
      groupName: "Group 1",
      enrollments: [
        Enrollment(
          participant: _participant,
          redeemed: false,
          groupId: groupId,
          status: EnrollmentStatus.enrolled,
          benefits: [],
        ),
      ],
    );
    return await _addGroup(group1);
  }

  Future<Group> _addToAvailableGroup() async {
    final firstAvailableGroup = _getFirstAvialableGroup();

    firstAvailableGroup.enrollments.add(
      Enrollment(
        participant: _participant,
        status: EnrollmentStatus.enrolled,
        redeemed: false,
        groupId:
            _generateGroupId(number: _groups.indexOf(firstAvailableGroup) + 1),
        benefits: [],
      ),
    );

    return await repository
        .updateGroup(
          firstAvailableGroup,
        )
        .then((_) => firstAvailableGroup);
  }

  Group _getFirstAvialableGroup() =>
      _groups.firstWhere((g) => g.isNotFull(_groupSize));

  Future<Group> _addToNewGroup() async {
    final newGroupNumber = _lastGroupNumber + 1;

    final groupId = _generateGroupId(number: newGroupNumber);

    final group = Group(
      researchId: _researchId,
      groupName: "Group $newGroupNumber",
      enrollments: [
        Enrollment(
            groupId: groupId,
            participant: _participant,
            status: EnrollmentStatus.enrolled,
            benefits: [],
            redeemed: false)
      ],
      groupId: groupId,
    );

    return await _addGroup(group);
  }

  bool _allGroupsAreFull() {
    for (final group in _groups) {
      if (group.isNotFull(_groupSize)) return false;
    }
    return true;
  }

  String _generateGroupId({required int number}) => Formatter.formatGroupId(
        number: number,
        title: _title,
      );

  //first group index is zero, but first group name is Group 1
  // so last group number will be its index + 1

  Future<Group> _addGroup(Group group) async =>
      await repository.addGroup(group);
}
