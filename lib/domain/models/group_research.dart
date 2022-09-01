import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupResearch extends Research {
  GroupResearch(Map<String, dynamic> jSON) : super(jSON);

  int get numberOfGroups => data['numberOfGroups'];
  int get groupSize => data['groupSize'];
  List<Group> get groups =>
      (data['groups'] as List).map((e) => Group.fromMap(e)).toList();

  int get groupsLength => data['groupsLength'] ?? 0;

  @override
  toMap() {
    final data = super.toMap();

    data['numberOfGroups'] = numberOfGroups;
    data['groupSize'] = groupSize;
    data['groups'] = groups.map((g) => g.toMap()).toList();
    data['groups']

    return data;
  }

  @override
  toPartialMap() {
    final data = super.toPartialMap();

    data['numberOfGroups'] = numberOfGroups;
    data['groupSize'] = groupSize;
    data['groups'] = groups.map((g) => g.toMap()).toList();

    return data;
  }

  // @override
  // GroupResearch get idenitifer => GroupResearch(data);

  factory GroupResearch.copy(
          Research research, int numberOfGroups, int groupSize) =>
      GroupResearch({
        ...research.toMap(),
        'sampleSize': groupSize * numberOfGroups,
        'numberOfGroups': numberOfGroups,
        'groupSize': groupSize,
        'groups': const [],
        'isGroupResearch': true,
      });

  @override
  GroupResearch copyWith(Map<String, dynamic> newData) => GroupResearch(
      {...data, ...newData..removeWhere((key, value) => value == null)});

  String getFirstNonFullGroupId() => "";

  @override
  String toString() => toMap().toString();

  @override
  List<Object> get props => [toMap()];
  ////////////////////////////////////
  void addUniqueBenefit(Enrollment enrollment, Benefit benefitToInsert) {
    for (final group in groups) {
      bool alreadyInserted = false;

      for (var benefit in enrollment.benefits) {
        benefit.benefitName == benefitToInsert.benefitName
            ? alreadyInserted = true
            : null;
      }
      int partIndex =
          group.getParticipantIndex(enrollment.participant.participantId);

      if (partIndex != -1) {
        if (alreadyInserted) {
          group.removeBenefit(partIndex, benefitToInsert.benefitName);
        }

        group.addBenefit(partIndex, benefitToInsert);
      }
    }
  }

  List<Enrollment> getAllEnrollments() => [
        for (final g in groups)
          for (final enrollment in g.enrollments) enrollment
      ];

  List<Participant> getAllParticipants() => [
        for (final g in groups)
          for (final enrollment in g.enrollments) enrollment.participant
      ];

  List<Participant> getAllParticipantsAt(int groupIndex) => [
        for (final enrollment in groups[groupIndex].enrollments)
          enrollment.participant
      ];

  ///key value, where key is group index, and value is index in group
  int getParticipantGroupIndex(String participantId) {
    int indexInGroup = -1;
    for (final group in groups) {
      indexInGroup = group.getParticipantIndex(participantId);
      if (indexInGroup != -1) return groups.indexOf(group);
    }

    return -1;
  }

  void updateParticipant(Participant participant) {
    int indexInGroup = -1;
    for (final group in groups) {
      indexInGroup = group.getParticipantIndex(participant.participantId);
      if (indexInGroup != -1) {
        groups[groups.indexOf(group)]
            .updateEnrollment(participant, indexInGroup);
      }
    }
  }
}
