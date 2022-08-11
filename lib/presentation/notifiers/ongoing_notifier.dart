import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/utilities/utilities.dart';
import 'package:reach_research/research.dart';

//after creation
class OngoingResearchNotifier extends StateNotifier<Research>
    implements BaseOngoingResearch {
  final Reader read;
  late ResearchsRepository repository;
  OngoingResearchNotifier(this.read, Research research) : super(research) {
    repository = read(researchsRepoPvdr);

    state = research;
  }
  Future<void> updateData() async => await repository.updateDocument(state);

  void updateState(Research research) => state = research;

  void addUnifiedBenefit({
    required Benefit benefit,
  }) {
    if (state is GroupResearch) {
      _addGroupUnifiedBenefit(benefit);
    } else {
      _addSingularUnifiedBenefit(benefit);
    }
  }

  void _addSingularUnifiedBenefit(Benefit benefit) {
    final enrollments = (state as SingularResearch).enrollments;

    for (var enrollment in enrollments) {
      bool alreadyInserted = false;
      for (var b in enrollment.benefits) {
        if (b.benefitName == benefit.benefitName) alreadyInserted = true;
      }

      if (alreadyInserted) {
        enrollment.benefits
            .removeWhere((b) => b.benefitName == benefit.benefitName);
      }
      enrollment.benefits.add(benefit);
    }

    state = copyResearchWith(state, enrollments: enrollments);
  }

  void _addGroupUnifiedBenefit(Benefit benefit) {
    final groups = (state as GroupResearch).groups;
    for (var group in groups) {
      for (var enrollment in group.participants) {
        bool alreadyInserted = false;
        for (var b in enrollment.benefits) {
          if (b.benefitName == benefit.benefitName) alreadyInserted = true;
        }
        if (alreadyInserted) {
          enrollment.benefits
              .removeWhere((b) => b.benefitName == benefit.benefitName);
        }

        enrollment.benefits.add(benefit);
      }
    }
    state = copyResearchWith(state, groups: groups);
  }

  void addUniqueBenefit({
    required Benefit benefit,
    required EnrolledTo enrollment,
  }) {
    if (state is GroupResearch) {
      _addGroupUniqueBenefit(enrollment, benefit);
    } else if (state is SingularResearch) {
      _addSingularUniqueBenefit(enrollment, benefit);
    }
  }

  void _addGroupUniqueBenefit(EnrolledTo enrollment, Benefit benefit) {
    final groups = (state as GroupResearch).groups;

    for (var group in groups) {
      bool alreadyInserted = false;

      for (var b in enrollment.benefits) {
        b.benefitName == benefit.benefitName ? alreadyInserted = true : null;
      }
      int currentEnrollmentIndex = group.participants.indexWhere((e) =>
          e.participant.participantId == enrollment.participant.participantId);
      if (currentEnrollmentIndex != -1) {
        if (alreadyInserted) {
          group.participants[currentEnrollmentIndex].benefits
              .removeWhere((b) => b.benefitName == benefit.benefitName);
        }

        group.participants[currentEnrollmentIndex].benefits.add(benefit);
      }
    }
    state = copyResearchWith(state, groups: groups);
  }

  void _addSingularUniqueBenefit(EnrolledTo enrollment, Benefit benefit) {
    final enrollments = (state as SingularResearch).enrollments;

    bool alreadyInserted = false;

    for (var b in enrollment.benefits) {
      if (b.benefitName == benefit.benefitName) alreadyInserted = true;
    }
    int currentEnrollmentIndex = enrollments.indexWhere((e) =>
        e.participant.participantId == enrollment.participant.participantId);
    if (alreadyInserted) {
      enrollments[currentEnrollmentIndex]
          .benefits
          .removeWhere((b) => b.benefitName == benefit.benefitName);
    }

    enrollments[currentEnrollmentIndex].benefits.add(benefit);

    state = copyResearchWith(state, enrollments: enrollments);
  }

  @override
  Future<void> addMeeting(Meeting meeting) async {
    state = copyResearchWith(state, meetings: [...state.meetings, meeting]);
    await updateData();
  }

  @override
  Future<void> deleteMeeting(Meeting meeting) async {
    state = copyResearchWith(state, meetings: state.meetings..remove(meeting));
    await updateData();
  }

  @override
  Future<void> editMeeting(int index, Meeting meeting) async {
    final meetings = state.meetings;
    state = copyResearchWith(
      state,
      meetings: [
        for (final m in meetings)
          if (meetings.indexOf(m) == index) meeting else m,
      ],
    );
    await updateData();
  }

  @override
  Future<void> togglePhase(
    int index,
  ) async {
    final phases = state.phases;
    state = copyResearchWith(
      state,
      phases: [
        for (final p in phases)
          if (phases.indexOf(p) == index)
            p.copyWith(isChecked: !p.isChecked)
          else
            p,
      ],
    );
    await updateData();
  }

  @override
  Future<void> changeGroupName(int groupIndex, String newName) async {
    final groupResearch = (state as GroupResearch);
    final groups = groupResearch.groups;

    groups[groupIndex] = groups[groupIndex].copyWith(newName);

    state = copyResearchWith(groupResearch, groups: groups);
    await updateData();
  }

  @override
  Future<void> changeParticipantGroup(
      {required int participantIndex,
      required int prevIndex,
      required int newIndex}) async {
    final groupResearch = (state as GroupResearch);
    final groups = groupResearch.groups;

    EnrolledTo participantToChange =
        groups[prevIndex].participants[participantIndex];
    groups[prevIndex].participants.remove(participantToChange);
    groups[newIndex].participants.add(participantToChange);
    state = copyResearchWith(groupResearch, groups: groups);
    await updateData();
  }

  @override
  Future<bool> deleteGroup(int index) async {
    GroupResearch groupResearch = (state as GroupResearch);

    final groups = groupResearch.groups;

    if (groups.length == 1) return false;
    final length = groups.length;

    for (int i = 0; i < length; i++) {
      if (index == i) {
        groupResearch = copyResearchWith(groupResearch,
            numberOfGroups: groupResearch.numberOfGroups - 1,
            numberOfEnrolled: groupResearch.numberOfEnrolled -
                groups[index].participants.length) as GroupResearch;

        for (final e in groups[index].participants) {
          groupResearch.enrolledIds.remove(e.participant.participantId);
        }

        groups.removeAt(index);
      } else if (index < i) {
        //we need to rename groups
        // i - 1 since length is reduced after removal
        //we will not enter to this scope until the group was removed
        changeGroupName(i - 1, "Group $i");
      }
    }

    state = copyResearchWith(groupResearch, groups: groups);
    await updateData();
    return true;
  }

  @override
  Future<void> kickParticipant(String participantId) async {
    final groupResearch = (state as GroupResearch);
    final groups = groupResearch.groups;

    int participantIndex = -1;
    int participantGroupIndex = -1;
    for (final g in groups) {
      participantIndex = g.participants.indexWhere(
          (element) => element.participant.participantId == participantId);
      if (participantIndex != -1) {
        participantGroupIndex = groups.indexOf(g);
        break;
      }
    }
    groupResearch.enrolledIds.remove(participantId);
    groups[participantGroupIndex].participants.removeAt(participantIndex);

    state = copyResearchWith(
      groupResearch,
      numberOfEnrolled: groupResearch.numberOfEnrolled - 1,
    );

    await updateData();
  }

  @override
  Future<void> requestParticipants(int number) async {
    state = copyResearchWith(
      state,
      requestJoiners: 0,
      requestedParticipantsNumber: number,
      isRequestingParticipants: true,
    );
    await updateData();
  }

  @override
  Future<void> addEmptyGroup() async {
    final groupResearch = (state as GroupResearch);
    final groups = groupResearch.groups;

    final timeStamp = Formatter.formatTimeId();
    final groupsLength = groups.length;

    groups.add(
      Group(
        groupId:
            "Group ${groupsLength + 1} - ${groupResearch.title} - $timeStamp",
        groupName: "Group ${groupsLength + 1}",
        participants: [],
      ),
    );

    state = copyResearchWith(
      groupResearch,
      numberOfEnrolled: groupResearch.numberOfGroups + 1,
    );

    await updateData();
  }

  Future<void> stopRequest() async {
    state = copyResearchWith(state,
        isRequestingParticipants: false,
        requestedParticipantsNumber: 0,
        requestJoiners: 0);
    await updateData();
  }

  Future<void> editRequest(int newNumber) async {
    state = copyResearchWith(
      state,
      requestedParticipantsNumber: newNumber,
    );
    await updateData();
  }
}
