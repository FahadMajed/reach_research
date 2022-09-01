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
