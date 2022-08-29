//addParticipant

import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddParticipantParams {
  final Participant participant;
  final String? researchId;
  AddParticipantParams({
    required this.participant,
    this.researchId = "",
  });
}

class AddParticipantToGroupParams extends AddParticipantParams {
  final List<Group> groups;
  final GroupResearch groupResearch;

  AddParticipantToGroupParams({
    required super.participant,
    required this.groups,
    required this.groupResearch,
  });
}
