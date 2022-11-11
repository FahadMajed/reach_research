import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupResearch extends Research {
  late final int numberOfGroups;
  late final int groupSize;

  GroupResearch({
    required this.numberOfGroups,
    required this.groupSize,
    required super.researcher,
    required super.researchId,
    required super.researchState,
    required super.title,
    required super.desc,
    required super.category,
    required super.criteria,
    required super.questions,
    required super.benefits,
    required super.isGroupResearch,
    required super.numberOfEnrolled,
    required super.sampleSize,
    required super.schedule,
    required super.image,
    required super.enrolledIds,
    required super.phases,
    required super.meetings,
    required super.rejectedIds,
    super.partsRequest,
  });

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

  GroupResearch copyWith2({
    int? numberOfGroups,
    int? groupSize,
    Researcher? researcher,
    String? researchId,
    ResearchState? researchState,
    String? title,
    String? desc,
    String? category,
    Map<String, Criterion>? criteria,
    List<CustomizedQuestion>? questions,
    List<Benefit>? benefits,
    bool? isGroupResearch,
    int? numberOfEnrolled,
    int? sampleSize,
    Schedule? schedule,
    String? image,
    List? enrolledIds,
    List? rejectedIds,
    List<Phase>? phases,
    List<Meeting>? meetings,
    ParticipantsRequest? partsRequest,
  }) {
    return GroupResearch(
      numberOfGroups: numberOfGroups ?? this.numberOfGroups,
      groupSize: groupSize ?? this.groupSize,
      researcher: researcher ?? this.researcher,
      researchId: researchId ?? this.researchId,
      researchState: researchState ?? this.researchState,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      category: category ?? this.category,
      criteria: criteria ?? this.criteria,
      questions: questions ?? this.questions,
      benefits: benefits ?? this.benefits,
      isGroupResearch: isGroupResearch ?? this.isGroupResearch,
      numberOfEnrolled: numberOfEnrolled ?? this.numberOfEnrolled,
      sampleSize: sampleSize ?? this.sampleSize,
      schedule: schedule ?? this.schedule,
      image: image ?? this.image,
      enrolledIds: enrolledIds ?? this.enrolledIds,
      rejectedIds: rejectedIds ?? this.rejectedIds,
      phases: phases ?? this.phases,
      meetings: meetings ?? this.meetings,
      partsRequest: partsRequest ?? this.partsRequest,
    );
  }

  factory GroupResearch.copy(
    Research research,
    int numberOfGroups,
    int groupSize,
  ) =>
      GroupResearch(
        sampleSize: groupSize * numberOfGroups,
        numberOfGroups: numberOfGroups,
        groupSize: groupSize,
        researcher: research.researcher,
        researchId: research.researchId,
        researchState: research.researchState,
        title: research.title,
        desc: research.desc,
        category: research.category,
        criteria: research.criteria,
        questions: research.questions,
        benefits: research.benefits,
        schedule: research.schedule,
        meetings: research.meetings,
        image: research.image,
        rejectedIds: [],
        numberOfEnrolled: research.numberOfEnrolled,
        phases: research.phases,
        enrolledIds: research.enrolledIds,
        isGroupResearch: true,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupResearch && other.numberOfGroups == numberOfGroups && other.groupSize == groupSize;
  }

  @override
  int get hashCode => numberOfGroups.hashCode ^ groupSize.hashCode;

  @override
  String toString() => 'GroupResearch(numberOfGroups: $numberOfGroups, groupSize: $groupSize)';
}
