import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class GroupsRepository {
  Future<Group> getGroup(String id);

  Future<List<Group>> getGroupsForResearch(String researchId);

  Future<String> getAvailableGroupId(
    String researchId,
    int groupSize,
  );

  Future<Group> addGroup(Group newGroup);

  Future<void> updateGroup(Group group);

  Future<void> removeGroup(Group group);

  Future<void> updateGroupNumber(String groupId, int newNumber);

  Future<void> updateParticipant(
    String groupId,
    Participant participant,
  );

  Future<void> updateEnrollment(
    String groupId,
    Enrollment enrollment,
  );

  Future<void> markRedeemed(Enrollment enrollment);

  Future<void> changeParticipantGroup(
    String fromId,
    String toId,
    Enrollment participantToChange,
  );

  Future<void> addEnrollmentToGroup(
    String groupId,
    Enrollment enrollment,
  );

  Future<void> removeEnrollmentFromGroup(
    String groupId,
    Enrollment enrollment,
  );

  Future<int> getGroupsCountForResearch(String researchId);

  ///returns participant enrollment from the group
  Future<Enrollment> getParticipantEnrollment(String participantId, String researchId);
}

abstract class BaseGroupsActions {}
