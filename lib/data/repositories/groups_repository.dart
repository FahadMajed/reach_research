import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/models/models.dart';

class GroupsRepository extends BaseRepository<Group, void> {
  GroupsRepository({required super.remoteDatabase});

  Future<List<Group>> getGroupsForResearch(String researchId) async =>
      await getQuery(where('researchId', isEqualTo: researchId));

  Future<Group?> getFirstAvailableGroup(
    String researchId,
    int groupSize,
  ) async =>
      await getQuery(
        where('researchId', isEqualTo: researchId)
            .where('numberOfEnrolled', isLessThan: groupSize)
            .limit(1),
      ).then(
        (groups) => groups.isEmpty ? null : groups.first,
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
}

final groupsRepoPvdr = Provider(
  (ref) => GroupsRepository(
    remoteDatabase: RemoteDatabase(
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
