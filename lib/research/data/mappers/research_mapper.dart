// ignore_for_file: avoid_renaming_method_parameters

import 'package:reach_core/core/core.dart';
import 'package:reach_research/lib.dart';
import 'package:reach_research/research.dart';

class ResearchMapper {
  static Research fromMap(Map<String, dynamic> data) {
    Map<String, Criterion> criteria = {};

    if (data['criteria'] != null) {
      for (String key in data['criteria'].keys) {
        criteria[key] = criterionFromMap(data['criteria'][key]);
      }
    }

    return Research(
        researchId: data['researchId'] ?? '',
        isGroupResearch: data["isGroupResearch"] ?? false,
        researcher: ResearcherMapper.fromMap(data['researcher']),
        researchState: ResearchState.values[data['researchState'] ?? 0],
        title: data["title"] ?? '',
        desc: data["desc"] ?? '',
        category: data['category'] ?? '',
        criteria: criteria,
        questions: QuestionsMapper.fromMapList(data),
        benefits: BenefitsMapper.fromMapList(data),
        meetings: MeetingsMapper.fromMapList(data),
        schedule: ScheduleMapper.fromMap(data['schedule']),
        image: data['image'] ?? 'f&b4.jpg',
        sampleSize: data["sampleSize"] ?? 1,
        numberOfEnrolled: data['numberOfEnrolled'] ?? 0,
        phases: PhasesMapper.fromMapList(data),
        enrolledIds: (data["enrolledIds"] as List),
        partsRequest: PartsRequestMapper.fromMap(data["participantsRequest"]),
        rejectedIds: data['rejectedIds'] ?? []);
  }

  static Map<String, Object?> toMap(Research research) => {
        'researchId': research.researchId,
        'title': research.title,
        'desc': research.desc,
        'category': research.category,
        'image': research.image,
        'sampleSize': research.sampleSize,
        'numberOfEnrolled': research.numberOfEnrolled,
        'researchState': research.researchState.index,
        'criteria': research.criteria.map((name, criteria) => MapEntry(name, criterionToMap(criteria))),
        'questions': QuestionsMapper.toMapList(research.questions),
        'benefits': BenefitsMapper.toMapList(research.benefits),
        'meetings': MeetingsMapper.toMapList(research.meetings),
        'phases': PhasesMapper.toMapList(research.phases),
        'schedule': ScheduleMapper.toMap(research.schedule),
        'participantsRequest': PartsRequestMapper.toMap(research.partsRequest),
        'researcher': ResearcherMapper.toResearchMap(research.researcher),
        'enrolledIds': research.enrolledIds,
        'rejectedIds': research.rejectedIds,
        'isGroupResearch': research.isGroupResearch,
      };

  static Map<String, Object?> groupToMap(GroupResearch research) => {
        ...toMap(research),
        'groupSize': research.groupSize,
        'numberOfGroups': research.numberOfGroups,
      };

  static GroupResearch groupfromMap(data) => GroupResearch.copy(
        fromMap(data),
        data['numberOfGroups'],
        data['groupSize'],
      );
}
