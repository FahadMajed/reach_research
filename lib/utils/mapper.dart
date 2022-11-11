import 'package:reach_research/research.dart';

Research researchFromMap(data) =>
    data["isGroupResearch"] ?? false ? ResearchMapper.groupfromMap(data) : ResearchMapper.fromMap(data);

Map<String, Object?> researchToMap(Research research) =>
    research is GroupResearch ? ResearchMapper.groupToMap(research) : ResearchMapper.toMap(research);

Research copyResearchWith(
  Research toCopy, {
  // Researcher? researcher,
  // String? researchId,
  ResearchState? researchState,
  // String? title,
  // String? desc,
  // String? category,

  // Map<String, Criterion>? criteria,
  // List<Question>? questions,
  // List<Benefit>? benefits,
  int? sampleSize,
  List<Meeting>? meetings,

  // String? city,
  // String? image,
  int? numberOfEnrolled,
  List<Phase>? phases,
  List? enrolledIds,

  // bool? isGroupResearch,
  // int? numberOfGroups,
  // int? groupSize,
  ParticipantsRequest? partsRequest,
}) {
  return toCopy is GroupResearch
      ? toCopy.copyWith2(
          enrolledIds: enrolledIds,
          researchState: researchState,
          partsRequest: partsRequest,
          meetings: meetings,
          sampleSize: sampleSize,
          numberOfEnrolled: numberOfEnrolled,
          phases: phases,
        )
      : toCopy.copyWith(
          enrolledIds: enrolledIds,
          researchState: researchState,
          partsRequest: partsRequest,
          sampleSize: sampleSize,
          meetings: meetings,
          numberOfEnrolled: numberOfEnrolled,
          phases: phases,
        );
}

Criterion criterionFromMap(Map<String, dynamic> data) {
  if (data["condition"] == null) {
    return RangeCriterion.fromMap(data);
  } else {
    return ValueCriterion.fromMap(data);
  }
}

Map<String, dynamic> criterionToMap(Criterion criterion) =>
    criterion is RangeCriterion ? criterion.toMap() : (criterion as ValueCriterion).toMap();
