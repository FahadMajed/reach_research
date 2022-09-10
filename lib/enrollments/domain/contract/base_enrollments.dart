import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class BaseEnrollments {
  Future<void> kickParticipant(String participantId);

  Future<void> addParticipant(Participant participant);

  Future<void> addUniqueBenefit(Enrollment enrollment, Benefit benefit);

  Future<void> addUnifiedBenefit(Benefit benefit);
}
