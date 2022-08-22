import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

mixin GroupReserchNotifier on BaseResearchNotifier
    implements BaseGroupResearch {
  GroupResearch get groupResearch => state as GroupResearch;

  Group get _lastGroup => groupResearch.groups.last;
  List<Group> get _groups => groupResearch.groups;
  //first group index is zero, but first group name is Group 1
  // so last group number will be its index + 1
  int get _lastGroupNumber => _groups.indexOf(_lastGroup) + 1;

  @protected
  Future<void> addParticipantToGroup(Participant participant) async {
    final groupResearch = state as GroupResearch;

    if (groupResearch.groups.isEmpty) {
      _addFirstParticipant(participant);
    } else {
      if (_allGroupsAreFull()) {
        _addToNewGroup(participant);
      } else {
        _addToAvailableGroup(participant);
      }
    }
    await updateData();
  }

  void _addFirstParticipant(Participant participant) {
    final groupId = _generateGroupId(number: 1);

    final group1 = Group(
      groupId: groupId,
      groupName: "Group 1",
      enrollments: [
        Enrollment(
          participant: participant,
          redeemed: false,
          groupId: groupId,
          status: EnrollmentStatus.enrolled,
          benefits: [],
        ),
      ],
    );
    _addGroup(group1);
  }

  void _addToAvailableGroup(Participant participant) {
    final firstAvailableGroup = _getFirstAvialableGroup();

    firstAvailableGroup.enrollments.add(
      Enrollment(
        participant: participant,
        status: EnrollmentStatus.enrolled,
        redeemed: false,
        groupId:
            _generateGroupId(number: _groups.indexOf(firstAvailableGroup) + 1),
        benefits: [],
      ),
    );

    _updateGroup(firstAvailableGroup);
  }

  Group _getFirstAvialableGroup() =>
      _groups.firstWhere((g) => g.isNotFull(groupResearch.groupSize));

  void _addToNewGroup(Participant participant) {
    final newGroupNumber = _lastGroupNumber + 1;

    final groupId = _generateGroupId(number: newGroupNumber);

    final group = Group(
      groupName: "Group $newGroupNumber",
      enrollments: [
        Enrollment(
            groupId: groupId,
            participant: participant,
            status: EnrollmentStatus.enrolled,
            benefits: [],
            redeemed: false)
      ],
      groupId: groupId,
    );

    _addGroup(group);
  }

  bool _allGroupsAreFull() {
    for (final group in _groups) {
      if (group.isNotFull(groupResearch.groupSize)) return false;
    }
    return true;
  }

  void _decrementNumberOfGroups() => updateState(
        numberOfGroups: groupResearch.numberOfGroups - 1,
      );

  @override
  Future<void> addEmptyGroup() async {
    final timeStamp = Formatter.formatTimeId();
    final groupsLength = _groups.length;

    final emptyGroup = Group(
      groupId:
          "Group ${groupsLength + 1} - ${groupResearch.title} - $timeStamp",
      groupName: "Group ${groupsLength + 1}",
      enrollments: [],
    );

    _addGroup(emptyGroup);

    await updateData();
  }

  @override
  Future<void> removeGroup(int index) async {
    final groups = groupResearch.groups;

    if (groups.length == 1) throw CannotDeleteAllGroups();
    final length = groups.length;

    for (int i = 0; i < length; i++) {
      if (index == i) {
        //found

        for (final e in groups[index].enrollments) {
          decrementEnrollments(participantId: e.participant.participantId);
        }

        _removeGroupAt(index);
      } else if (index < i) {
        //we need to rename groups
        // i - 1 since length is reduced after removal
        //we will not enter to this scope until the group was removed
        _changeGroupName(i - 1, "Group $i");
      }
    }

    await updateData();
  }

  void _removeGroupAt(int toRemoveIndex) => updateState(
        groups: _groups..removeAt(toRemoveIndex),
        numberOfGroups: groupResearch.numberOfGroups - 1,
      );

  void _changeGroupName(int groupIndex, String newName) =>
      _updateGroup(_groups[groupIndex].copyWith(newName));

  @override
  Future<void> changeParticipantGroup({
    required int participantIndex,
    required int fromIndex,
    required int toIndex,
  }) async {
    final groups = groupResearch.groups;

    Enrollment participantToChange =
        groups[fromIndex].enrollments[participantIndex];
    groups[fromIndex].enrollments.remove(participantToChange);
    groups[toIndex].enrollments.add(participantToChange);
    updateState(groups: groups);
    await updateData();
  }

  @protected
  Future<void> kickParticipantFromGroup(String participantId) async {
    final groups = groupResearch.groups;

    int participantIndex = -1;
    int participantGroupIndex = -1;
    for (final group in groups) {
      participantIndex = group.getParticipantIndex(participantId);
      if (participantIndex != -1) {
        participantGroupIndex = groups.indexOf(group);
        break;
      }
    }

    final updatedGroup = groups[participantGroupIndex]
      ..enrollments.removeAt(participantIndex);

    _updateGroup(updatedGroup);
    await updateData();
  }

  @protected
  void addGroupUnifiedBenefit(Benefit benefitToInsert) {
    for (final group in _groups) {
      for (final enrollment in group.enrollments) {
        bool alreadyInserted = false;
        for (final benefit in enrollment.benefits) {
          if (benefit.benefitName == benefitToInsert.benefitName) {
            alreadyInserted = true;
          }
        }

        if (alreadyInserted) {
          enrollment.removeBenefit(benefitToInsert.benefitName);
        }

        enrollment.benefits.add(benefitToInsert);
      }
      _updateGroup(group);
    }
  }

  @protected
  void addGroupUniqueBenefit(Enrollment enrollment, Benefit benefitToInsert) {
    for (final group in _groups) {
      int partIndex =
          group.getParticipantIndex(enrollment.participant.participantId);

      if (partIndex != -1) {
        bool alreadyInserted = false;

        for (var benefit in enrollment.benefits) {
          benefit.benefitName == benefitToInsert.benefitName
              ? alreadyInserted = true
              : null;
        }

        if (alreadyInserted) {
          group.removeBenefit(partIndex, benefitToInsert.benefitName);
        }

        group.addBenefit(partIndex, benefitToInsert);

        _updateGroup(group);
      }
    }
  }

  void _updateGroup(Group updatedGroup) {
    updateState(
      groups: [
        for (final group in groupResearch.groups)
          if (group.groupId == updatedGroup.groupId) updatedGroup else group
      ],
    );
  }

  void _addGroup(Group group) {
    updateState(
      groups: [...groupResearch.groups, group],
      numberOfGroups: _groups.length + 1,
    );
  }

  String _generateGroupId({required int number}) => Formatter.formatGroupId(
        number: number,
        title: research.title,
      );
}
