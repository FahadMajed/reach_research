import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/models/models.dart';

abstract class BaseGroup {
  Future<void> changeParticipantGroup({
    required int participantIndex,
    required int fromIndex,
    required int toIndex,
  });

//returns kicked participants ids
  Future<List<String>> removeGroup(int groupIndex);

  Future<void> kickParticipant(int groupIndex, Participant participant);

  Future<void> addEmptyGroup();

  void addUniqueBenefit(
    Group group,
    Benefit benefit,
    Enrollment enrollment,
  );

  void addUnifiedBenefit(Benefit benefit);
}
