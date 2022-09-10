import 'package:reach_core/core/core.dart';
import 'package:reach_research/data/source/remote/groups_remote_database.dart';
import 'package:reach_research/domain/models/models.dart';

class GroupsRepository extends BaseRepository<Group, void> {
  GroupsRepository({required GroupsRemoteDatabase super.remoteDatabase});

  GroupsRemoteDatabase get db => remoteDatabase as GroupsRemoteDatabase;

  Future<List<Group>> getGroupsForResearch(String researchId) async =>
      await getQuery(where('researchId', isEqualTo: researchId));

  Future<String> getFirstAvailableGroupId(
    String researchId,
    int groupSize,
  ) async =>
      await getQuery(
        where('researchId', isEqualTo: researchId)
            .where('numberOfEnrolled', isLessThan: groupSize)
            .limit(1),
      ).then(
        (groups) => groups.isEmpty ? "" : groups.first.groupId,
        onError: (e) => throw e,
      );

  Future<Group> addGroup(Group newGroup) async => await create(
        newGroup,
        newGroup.groupId,
      ).then((value) => newGroup);

  Future<void> updateGroup(Group group) async => await updateData(
        group,
        group.groupId,
      );

  Future<void> removeGroup(Group group) async => delete(group.groupId);

  Future<void> updateGroupName(String groupId, String newName) async =>
      await updateField(groupId, 'groupName', newName);

  Future<void> updateParticipant(
    String researchId,
    Participant participant,
  ) async {
    final groups = await getQuery(where('researchId', isEqualTo: researchId));

    for (final group in groups) {
      await updateGroup(
        group.copyWith(
          enrollments: [
            for (final e in group.enrollments)
              if (e.partId == participant.participantId)
                e.copyWith(participant: participant)
              else
                e
          ],
        ),
      );
    }
  }

  Future<void> addEnrollmentToGroup(
          String groupId, Enrollment enrollment) async =>
      await db.addEnrollmentToGroup(
        groupId,
        enrollment,
      );

  Future<void> removeEnrollmentFromGroup(
    String groupId,
    Enrollment enrollment,
  ) async =>
      await db.removeEnrollmentFromGroup(
        groupId,
        enrollment,
      );
}

final groupsRepoPvdr = Provider(
  (ref) => GroupsRepository(
    remoteDatabase: GroupsRemoteDatabase(
      collectionPath: 'groups',
      fromMap: ((snapshot, _) => snapshot.data() == null
          ? Group.empty()
          : Group.fromMap(
              snapshot.data()!,
            )),
      toMap: (group, _) => group.toMap(),
      db: ref.read(databasePvdr),
    ),
  ),
);
