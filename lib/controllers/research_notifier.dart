import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/models/models.dart';
import 'package:reach_core/core/utilities/utilities.dart';
import 'package:reach_research/research.dart';

final researchPvdr = StateNotifierProvider<ResearchNotifier, Research>(
  (ref) => ResearchNotifier(
    ref.read(researchsRepoPvdr),
  ),
);

//after creation
class ResearchNotifier extends StateNotifier<Research> implements BaseResearch {
  final ResearchsRepository _repository;
  ResearchNotifier(this._repository) : super(Research.empty()) {
    state = Research.empty();
  }

  Research get research =>
      state is SingularResearch ? state : state as GroupResearch;

  GroupResearch get groupResearch => state as GroupResearch;

  SingularResearch get singularResearch => state as SingularResearch;

  void set(Research research) => state = research;

  Future<void> _updateData() async =>
      await _repository.updateData(research, research.researchId);

  Future<void> _updateField(String fieldName, dynamic fieldData) async =>
      await _repository.updateField(research.researchId, fieldName, fieldData);

  void _updateState(
          {List<EnrolledTo>? enrollments,
          Researcher? researcher,
          String? researchId,
          ResearchState? researchState,
          String? title,
          String? desc,
          String? category,
          Map<String, Criterion>? criteria,
          List<Question>? questions,
          List<Benefit>? benefits,
          int? sampleSize,
          int? numberOfMeetings,
          List? meetingsTimeSlots,
          List? meetingsDays,
          List? meetingsMethods,
          String? startDate,
          List<Meeting>? meetings,
          String? city,
          String? image,
          int? numberOfEnrolled,
          List<Phase>? phases,
          List? enrolledIds,
          List? rejectedIds,
          bool? isGroupResearch,
          int? numberOfGroups,
          int? groupSize,
          int? requestedParticipantsNumber,
          bool? isRequestingParticipants,
          int? requestJoiners,
          List<Group>? groups}) =>
      state = copyResearchWith(
        state,
        enrollments: enrollments,
        numberOfGroups: numberOfGroups,
        groupSize: groupSize,
        groups: groups,
        researcher: researcher,
        researchId: researchId,
        researchState: researchState,
        title: title,
        desc: desc,
        requestJoiners: requestJoiners,
        category: category,
        criteria: criteria,
        questions: questions,
        benefits: benefits,
        sampleSize: sampleSize,
        numberOfMeetings: numberOfMeetings,
        meetingsDays: meetingsDays,
        meetingsTimeSlots: meetingsTimeSlots,
        meetingsMethods: meetingsMethods,
        startDate: startDate,
        meetings: meetings,
        city: city,
        isRequestingParticipants: isRequestingParticipants,
        requestedParticipantsNumber: requestedParticipantsNumber,
        image: image,
        numberOfEnrolled: numberOfEnrolled,
        phases: phases,
        enrolledIds: enrolledIds,
        rejectedIds: rejectedIds,
        isGroupResearch: isGroupResearch,
      );

  Future<void> updateResearchState(ResearchState newState) async {
    _updateState(
      researchState: newState,
    );

    await _updateData();
  }

  @override
  Future<void> addPhases(List<Phase> phases) async {
    _updateState(
      researchState: ResearchState.ongoing,
      phases: phases,
    );

    await _updateData();
  }

  @override
  Future<void> addParticipant(Participant participant) async {
    if (research.sampleSize == research.numberOfEnrolled) {
      throw ResearchIsFull();
    }
    if (research.isGroupResearch) {
      _addParticipantToGroup(participant);
    } else {
      _addParticipantToSingle(participant);
    }

    _incrementEnrollments(participantId: participant.participantId);

    if (research.isRequestingParticipants) {
      _incrementRequestJoiners();

      if (research.requestedParticipantsNumber == research.requestJoiners) {
        stopRequest();
        return;
      }
    }

    await _updateData();
  }

  void _addParticipantToGroup(Participant participant) {
    if (groupResearch.groups.isEmpty) {
      final groupId = Formatter.formatGroupId(
        number: 1,
        title: research.title,
      );
      groupResearch.groups.add(
        Group(
          groupId: groupId,
          groupName: "Group 1",
          enrollments: [
            EnrolledTo(
                participant: participant,
                redeemed: false,
                groupId: groupId,
                status: EnrollmentStatus.enrolled,
                benefits: []),
          ],
        ),
      );
    } else {
      for (Group group in groupResearch.groups) {
        String currentGroupName = group.groupName;
        int currentGroupNumber = int.tryParse(currentGroupName.split(" ")[1])!;

        if (group.enrollments.length < groupResearch.groupSize) {
          group.enrollments.add(
            EnrolledTo(
              participant: participant,
              status: EnrollmentStatus.enrolled,
              redeemed: false,
              groupId: Formatter.formatGroupId(
                number: currentGroupNumber,
                title: research.title,
              ),
              benefits: [],
            ),
          );

          break;
        } else {
          // check if the last group is the full group, if so add new group
          if (group == groupResearch.groups.last) {
            final groupId = Formatter.formatGroupId(
              number: currentGroupNumber + 1,
              title: research.title,
            );
            groupResearch.groups.add(
              Group(
                groupName: "Group ${currentGroupNumber + 1}",
                enrollments: [
                  EnrolledTo(
                      groupId: groupId,
                      participant: participant,
                      status: EnrollmentStatus.enrolled,
                      benefits: [],
                      redeemed: false)
                ],
                groupId: groupId,
              ),
            );

            break;
          }
        }
      }
    }
  }

  void _addParticipantToSingle(Participant participant) =>
      singularResearch.enrollments.add(
        EnrolledTo(
          participant: participant,
          status: EnrollmentStatus.enrolled,
          benefits: [],
          groupId: '',
          redeemed: false,
        ),
      );

  @override
  void addUnifiedBenefit(Benefit benefit) {
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

    _updateState(enrollments: enrollments);
  }

  void _addGroupUnifiedBenefit(Benefit benefit) {
    final groupResearch = this.groupResearch..addUnifiedBenefit(benefit);

    _updateState(groups: groupResearch.groups);
  }

  @override
  void addUniqueBenefit(
    Benefit benefit,
    EnrolledTo enrollment,
  ) {
    if (state is GroupResearch) {
      _addGroupUniqueBenefit(enrollment, benefit);
    } else if (state is SingularResearch) {
      _addSingularUniqueBenefit(enrollment, benefit);
    }
  }

  void _addGroupUniqueBenefit(EnrolledTo enrollment, Benefit benefitToInsert) {
    final groupResearch = this.groupResearch
      ..addUniqueBenefit(enrollment, benefitToInsert);

    _updateState(groups: groupResearch.groups);
  }

  void _addSingularUniqueBenefit(
      EnrolledTo enrollment, Benefit benefitToInsert) {
    final singularResearch = this.singularResearch
      ..addUniqueBenefit(enrollment, benefitToInsert);

    _updateState(enrollments: singularResearch.enrollments);
  }

  @override
  Future<void> addMeeting(Meeting meeting) async {
    _updateState(meetings: [...research.meetings, meeting]);
    await _updateData();
  }

  @override
  Future<void> removeMeeting(Meeting meeting) async {
    _updateState(meetings: research.meetings..remove(meeting));
    await _updateData();
  }

  @override
  Future<void> editMeeting(int index, Meeting meeting) async {
    final meetings = research.meetings;
    _updateState(
      meetings: [
        for (final m in meetings)
          if (meetings.indexOf(m) == index) meeting else m,
      ],
    );

    await _updateData();
  }

  @override
  Future<void> togglePhase(
    int index,
  ) async {
    final phases = research.phases;
    _updateState(
      phases: [
        for (final p in phases)
          if (phases.indexOf(p) == index)
            p.copyWith(isChecked: !p.isChecked)
          else
            p,
      ],
    );

    await _updateData();
  }

  void _changeGroupName(int groupIndex, String newName) async {
    final groups = groupResearch.groups;

    groups[groupIndex] = groups[groupIndex].copyWith(newName);

    _updateState(groups: groups);
  }

  @override
  Future<void> changeParticipantGroup({
    required int participantIndex,
    required int fromIndex,
    required int toIndex,
  }) async {
    final groups = groupResearch.groups;

    EnrolledTo participantToChange =
        groups[fromIndex].enrollments[participantIndex];
    groups[fromIndex].enrollments.remove(participantToChange);
    groups[toIndex].enrollments.add(participantToChange);
    _updateState(groups: groups);
    await _updateData();
  }

  @override
  Future<void> removeGroup(int index) async {
    final groups = groupResearch.groups;

    if (groups.length == 1) throw CannotDeleteAllGroups();
    final length = groups.length;

    for (int i = 0; i < length; i++) {
      if (index == i) {
        //found
        _decrementNumberOfGroups();
        for (final e in groups[index].enrollments) {
          _decrementEnrollments(participantId: e.participant.participantId);
        }

        groups.removeAt(index);
      } else if (index < i) {
        //we need to rename groups
        // i - 1 since length is reduced after removal
        //we will not enter to this scope until the group was removed
        _changeGroupName(i - 1, "Group $i");
      }
    }

    _updateState(groups: groups);
    await _updateData();
  }

  @override
  Future<void> kickParticipant(String participantId) async {
    if (state is GroupResearch) {
      _kickParticipantFromGroup(participantId);
    } else {
      _kickParticipantFromEnrollments(participantId);
    }

    _decrementEnrollments(participantId: participantId);

    await _updateData();
  }

  void _kickParticipantFromGroup(String participantId) {
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

    groups[participantGroupIndex].enrollments.removeAt(participantIndex);

    _updateState(groups: groups);
  }

  void _kickParticipantFromEnrollments(String participantId) => _updateState(
      enrollments: singularResearch.enrollments
        ..removeWhere((enrollment) =>
            enrollment.participant.participantId == participantId));

  @override
  Future<void> requestParticipants(int number) async {
    _updateState(
      requestJoiners: 0,
      sampleSize: research.numberOfEnrolled + number,
      requestedParticipantsNumber: number,
      isRequestingParticipants: true,
    );

    await _updateData();
  }

  @override
  Future<void> addEmptyGroup() async {
    final groups = groupResearch.groups;

    final timeStamp = Formatter.formatTimeId();
    final groupsLength = groups.length;

    groups.add(
      Group(
        groupId:
            "Group ${groupsLength + 1} - ${groupResearch.title} - $timeStamp",
        groupName: "Group ${groupsLength + 1}",
        enrollments: [],
      ),
    );

    _updateState(
      groups: groups,
      numberOfGroups: groupResearch.numberOfGroups + 1,
    );

    await _updateData();
  }

  @override
  Future<void> stopRequest() async {
    _updateState(
        isRequestingParticipants: false,
        sampleSize: research.numberOfEnrolled,
        requestedParticipantsNumber: 0,
        requestJoiners: 0);

    await _updateData();
  }

  @override
  Future<void> editRequest(int newNumber) async {
    _updateState(requestedParticipantsNumber: newNumber);
    await _updateData();
  }

  void _decrementEnrollments({required String participantId}) => _updateState(
        numberOfEnrolled: research.numberOfEnrolled - 1,
        enrolledIds: [
          ...research.enrolledIds
            ..remove(
              participantId,
            ),
        ],
      );

  void _incrementEnrollments({required String participantId}) => _updateState(
        numberOfEnrolled: research.numberOfEnrolled + 1,
        enrolledIds: [
          ...research.enrolledIds,
          participantId,
        ],
      );

  void _incrementRequestJoiners() => _updateState(
        requestJoiners: research.requestJoiners + 1,
      );

  void _decrementNumberOfGroups() => _updateState(
        numberOfGroups: (state as GroupResearch).numberOfGroups - 1,
      );

  Future<void> endResearch() async {
    _updateState(
      researchState: ResearchState.redeeming,
    );

    await _updateData();
  }
}
