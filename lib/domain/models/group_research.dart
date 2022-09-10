import 'package:reach_research/research.dart';

class GroupResearch extends Research {
  GroupResearch(Map<String, dynamic> jSON) : super(jSON);

  int get numberOfGroups => data['numberOfGroups'];
  int get groupSize => data['groupSize'];

  /// the number of created groups, because groups are created dynamically.
  int get groupsLength => data['groupsLength'];

  @override
  toMap() {
    final data = super.toMap();

    data['numberOfGroups'] = numberOfGroups;
    data['groupSize'] = groupSize;

    data['groupsLength'] = groupsLength;

    return data;
  }

  @override
  toPartialMap() {
    final data = super.toPartialMap();

    data['numberOfGroups'] = numberOfGroups;
    data['groupSize'] = groupSize;

    return data;
  }

  @override
  String toString() => toMap().toString();

  factory GroupResearch.copy(
          Research research, int numberOfGroups, int groupSize) =>
      GroupResearch({
        ...research.toMap(),
        'sampleSize': groupSize * numberOfGroups,
        'numberOfGroups': numberOfGroups,
        'groupSize': groupSize,
        'isGroupResearch': true,
        'groupsLength': 0,
      });

  @override
  GroupResearch copyWith(Map<String, dynamic> newData) => GroupResearch(
      {...data, ...newData..removeWhere((key, value) => value == null)});

  String getFirstNonFullGroupId() => "";

  @override
  List<Object> get props => [toMap()];
  // ////////////////////////////////////

  // List<Enrollment> getAllEnrollments() => [
  //       for (final g in groups)
  //         for (final enrollment in g.enrollments) enrollment
  //     ];

  // List<Participant> getAllParticipants() => [
  //       for (final g in groups)
  //         for (final enrollment in g.enrollments) enrollment.participant
  //     ];

  // List<Participant> getAllParticipantsAt(int groupIndex) => [
  //       for (final enrollment in groups[groupIndex].enrollments)
  //         enrollment.participant
  //     ];

  // ///key value, where key is group index, and value is index in group
  // int getParticipantGroupIndex(String participantId) {
  //   int indexInGroup = -1;
  //   for (final group in groups) {
  //     indexInGroup = group.getParticipantIndex(participantId);
  //     if (indexInGroup != -1) return groups.indexOf(group);
  //   }

  //   return -1;
  // }
}
