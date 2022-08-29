import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/models/models.dart';

class GroupsRepository extends BaseRepository<Group, void> {
  GroupsRepository({required super.remoteDatabase});

  Future<List<Group>> getGroupsForResearch(String researchId) async =>
      await getQuery(remoteDatabase.where('researchId', isEqualTo: researchId));

  Future<Group> addGroup(Group newGroup) async => await create(
        newGroup,
        newGroup.groupId,
      ).then((value) => newGroup);

  Future<void> updateGroup(Group group) async => await updateData(
        group,
        group.groupId,
      );

  Future<void> removeGroup(Group group) async => delete(group.groupId);

  updateGroupName(String groupId, String newName) async =>
      await updateField(groupId, 'groupName', newName);
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
