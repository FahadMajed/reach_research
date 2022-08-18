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
  final ResearchsRepository repository;
  ResearchNotifier(this.repository) : super(Research.empty()) {
    state = Research.empty();
  }

  void set(Research research) => state = research;

  Future<void> _updateData() async => await repository.updateDocument(state);

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
          List? prefferedTimes,
          List? prefferedDays,
          List? prefferedMethods,
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
      state is SingularResearch
          ? state = (state as SingularResearch).copyWith2(
              enrollments:
                  enrollments ?? (state as SingularResearch).enrollments,
              researcher: researcher ?? state.researcher,
              researchId: researchId ?? state.researchId,
              state: researchState ?? state.state,
              requestJoiners: requestJoiners ?? state.requestJoiners,
              title: title ?? state.title,
              desc: desc ?? state.desc,
              category: category ?? state.category,
              criteria: criteria ?? state.criteria,
              questions: questions ?? state.questions,
              benefits: benefits ?? state.benefits,
              sampleSize: sampleSize ?? state.sampleSize,
              numberOfMeetings: numberOfMeetings ?? state.numberOfMeetings,
              prefferedTimes: prefferedTimes ?? state.preferredTimes,
              prefferedDays: prefferedDays ?? state.preferredDays,
              prefferedMethods: prefferedMethods ?? state.preferredMethods,
              startDate: startDate ?? state.startDate,
              meetings: meetings ?? state.meetings,
              city: city ?? state.city,
              image: image ?? state.image,
              numberOfEnrolled: numberOfEnrolled ?? state.numberOfEnrolled,
              phases: phases ?? state.phases,
              isRequestingParticipants:
                  isRequestingParticipants ?? state.isRequestingParticipants,
              requestedParticipantsNumber: requestedParticipantsNumber ??
                  state.requestedParticipantsNumber,
              enrolledIds: enrolledIds ?? state.enrolledIds,
              rejectedIds: rejectedIds ?? state.rejectedIds,
              isGroupResearch: isGroupResearch ?? state.isGroupResearch,
            )
          : state = (state as GroupResearch).copyWith2(
              numberOfGroups:
                  numberOfGroups ?? (state as GroupResearch).numberOfGroups,
              groupSize: groupSize ?? (state as GroupResearch).groupSize,
              groups: groups ?? (state as GroupResearch).groups,
              researcher: researcher ?? state.researcher,
              researchId: researchId ?? state.researchId,
              state: researchState ?? state.state,
              title: title ?? state.title,
              desc: desc ?? state.desc,
              requestJoiners: requestJoiners ?? state.requestJoiners,
              category: category ?? state.category,
              criteria: criteria ?? state.criteria,
              questions: questions ?? state.questions,
              benefits: benefits ?? state.benefits,
              sampleSize: sampleSize ?? state.sampleSize,
              numberOfMeetings: numberOfMeetings ?? state.numberOfMeetings,
              prefferedTimes: prefferedTimes ?? state.preferredTimes,
              prefferedDays: prefferedDays ?? state.preferredDays,
              prefferedMethods: prefferedMethods ?? state.preferredMethods,
              startDate: startDate ?? state.startDate,
              meetings: meetings ?? state.meetings,
              city: city ?? state.city,
              isRequestingParticipants:
                  isRequestingParticipants ?? state.isRequestingParticipants,
              requestedParticipantsNumber: requestedParticipantsNumber ??
                  state.requestedParticipantsNumber,
              image: image ?? state.image,
              numberOfEnrolled: numberOfEnrolled ?? state.numberOfEnrolled,
              phases: phases ?? state.phases,
              enrolledIds: enrolledIds ?? state.enrolledIds,
              rejectedIds: rejectedIds ?? state.rejectedIds,
              isGroupResearch: isGroupResearch ?? state.isGroupResearch,
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
      researchState: ResearchState.Ongoing,
      phases: phases,
    );

    await _updateData();
  }

  @override
  Future<void> addParticipant(Participant participant) async {
    if (state.sampleSize == state.numberOfEnrolled) {
      throw ResearchIsFull();
    }
    if (state.isGroupResearch) {
      _addParticipantToGroup(participant);
    } else {
      _addParticipantToSingle(participant);
    }

    _incrementEnrollments(participantId: participant.participantId);

    if (state.isRequestingParticipants) {
      _incrementRequestJoiners();

      if (state.requestedParticipantsNumber == state.requestJoiners) {
        stopRequest();
        return;
      }
    }

    await _updateData();
  }

  void _addParticipantToGroup(Participant participant) {
    final research = state as GroupResearch;

    if (research.groups.isEmpty) {
      final groupId = Formatter.formatGroupId(
        number: 1,
        title: research.title,
      );
      research.groups.add(
        Group(
          groupId: groupId,
          groupName: "Group 1",
          participants: [
            EnrolledTo(
                participant: participant,
                redeemed: false,
                groupId: groupId,
                status: "enrolled",
                benefits: []),
          ],
        ),
      );
    } else {
      for (Group group in research.groups) {
        String currentGroupName = group.groupName;
        int currentGroupNumber = int.tryParse(currentGroupName.split(" ")[1])!;

        if (group.participants.length < research.groupSize) {
          group.participants.add(
            EnrolledTo(
              participant: participant,
              status: "enrolled",
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
          if (group == research.groups.last) {
            final groupId = Formatter.formatGroupId(
              number: currentGroupNumber + 1,
              title: research.title,
            );
            research.groups.add(
              Group(
                groupName: "Group ${currentGroupNumber + 1}",
                participants: [
                  EnrolledTo(
                      groupId: groupId,
                      participant: participant,
                      status: "enrolled",
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

  void _addParticipantToSingle(Participant participant) {
    final research = state as SingularResearch;

    research.enrollments.add(
      EnrolledTo(
        participant: participant,
        status: "enrolled",
        benefits: [],
        groupId: '',
        redeemed: false,
      ),
    );
  }

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
    final groupResearch = (state as GroupResearch)..addUnifiedBenefit(benefit);

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
    final groupResearch = (state as GroupResearch)
      ..addUniqueBenefit(enrollment, benefitToInsert);

    _updateState(groups: groupResearch.groups);
  }

  void _addSingularUniqueBenefit(
      EnrolledTo enrollment, Benefit benefitToInsert) {
    final research = (state as SingularResearch)
      ..addUniqueBenefit(enrollment, benefitToInsert);

    _updateState(enrollments: research.enrollments);
  }

  @override
  Future<void> addMeeting(Meeting meeting) async {
    _updateState(meetings: [...state.meetings, meeting]);
    await _updateData();
  }

  @override
  Future<void> removeMeeting(Meeting meeting) async {
    _updateState(meetings: state.meetings..remove(meeting));
    await _updateData();
  }

  @override
  Future<void> editMeeting(int index, Meeting meeting) async {
    final meetings = state.meetings;
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
    final phases = state.phases;
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
    final groupResearch = (state as GroupResearch);
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
    final groupResearch = (state as GroupResearch);
    final groups = groupResearch.groups;

    EnrolledTo participantToChange =
        groups[fromIndex].participants[participantIndex];
    groups[fromIndex].participants.remove(participantToChange);
    groups[toIndex].participants.add(participantToChange);
    _updateState(groups: groups);
    await _updateData();
  }

  @override
  Future<void> removeGroup(int index) async {
    GroupResearch groupResearch = (state as GroupResearch);

    final groups = groupResearch.groups;

    if (groups.length == 1) throw CannotDeleteAllGroups();
    final length = groups.length;

    for (int i = 0; i < length; i++) {
      if (index == i) {
        //found
        _decrementNumberOfGroups();
        for (final e in groups[index].participants) {
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
    final groupResearch = (state as GroupResearch);
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

    groups[participantGroupIndex].participants.removeAt(participantIndex);

    _updateState(groups: groups);
  }

  void _kickParticipantFromEnrollments(String participantId) => _updateState(
      enrollments: (state as SingularResearch).enrollments
        ..removeWhere((enrollment) =>
            enrollment.participant.participantId == participantId));

  @override
  Future<void> requestParticipants(int number) async {
    _updateState(
      requestJoiners: 0,
      sampleSize: state.numberOfEnrolled + number,
      requestedParticipantsNumber: number,
      isRequestingParticipants: true,
    );

    await _updateData();
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
        sampleSize: state.numberOfEnrolled,
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
        numberOfEnrolled: state.numberOfEnrolled - 1,
        enrolledIds: [
          ...state.enrolledIds
            ..remove(
              participantId,
            ),
        ],
      );

  void _incrementEnrollments({required String participantId}) => _updateState(
        numberOfEnrolled: state.numberOfEnrolled + 1,
        enrolledIds: [
          ...state.enrolledIds,
          participantId,
        ],
      );

  void _incrementRequestJoiners() => _updateState(
        requestJoiners: state.requestJoiners + 1,
      );

  void _decrementNumberOfGroups() => _updateState(
        numberOfGroups: (state as GroupResearch).numberOfGroups - 1,
      );

  Future<void> endResearch() async {
    _updateState(
      researchState: ResearchState.Redeeming,
    );

    await _updateData();
  }
}
