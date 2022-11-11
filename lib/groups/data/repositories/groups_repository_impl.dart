import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupsRepositoryImpl implements GroupsRepository {
  GroupsRepositoryImpl({
    required RemoteDatabase<Group, void> remoteDatabase,
  }) {
    _db = remoteDatabase;
  }

  late final RemoteDatabase<Group, void> _db;

  @override
  Future<Group> getGroup(String id) async => await _db.getDocument(id);

  @override
  Future<List<Group>> getGroupsForResearch(String researchId) async => await _db.getQuery(
        DatabaseQuery(
          [
            Where(
              'researchId',
              isEqualTo: researchId,
            )
          ],
        ),
      );

  @override
  Future<String> getAvailableGroupId(
    String researchId,
    int groupSize,
  ) async =>
      await _db
          .getQuery(
            DatabaseQuery(
              [
                Where(
                  'researchId',
                  isEqualTo: researchId,
                ),
                Where(
                  "numberOfEnrolled",
                  isLessThan: groupSize,
                )
              ],
              limit: 1,
            ),
          )
          .then(
            (groups) => groups.isEmpty ? "" : groups.first.groupId,
            onError: (e) => throw e,
          );

  @override
  Future<Group> addGroup(Group newGroup) async => await _db
      .createDocument(
        newGroup,
        newGroup.groupId,
      )
      .then((value) => newGroup);

  @override
  Future<void> updateGroup(Group group) async => await _db.updateDocument(
        group,
        group.groupId,
      );

  @override
  Future<void> removeGroup(Group group) async => _db.deleteDocument(group.groupId);

  @override
  Future<void> updateGroupNumber(String groupId, int newNumber) async => await _db.updateField(
        groupId,
        'groupNumber',
        newNumber,
      );

  @override
  Future<void> updateParticipant(
    String groupId,
    Participant participant,
  ) async {
    final group = await getGroup(groupId);

    await updateGroup(group.updateParticipant(participant));
  }

  @override
  Future<void> changeParticipantGroup(
    String fromId,
    String toId,
    Enrollment participantToChange,
  ) async {
    removeEnrollmentFromGroup(fromId, participantToChange);
    addEnrollmentToGroup(toId, participantToChange);
  }

  @override
  Future<void> addEnrollmentToGroup(
    String groupId,
    Enrollment enrollment,
  ) async =>
      await _db.updateDocumentRaw(
        {
          "enrollmentsIds": _db.arrayUnion([enrollment.partId]),
          "numberOfEnrolled": _db.increment(1),
          'enrollments': _db.arrayUnion([EnrollmentsMapper.toMap(enrollment)])
        },
        groupId,
      );

  @override
  Future<void> removeEnrollmentFromGroup(
    String groupId,
    Enrollment enrollment,
  ) async =>
      await _db.updateDocumentRaw(
        {
          "enrollmentsIds": _db.arrayRemove([enrollment.partId]),
          "numberOfEnrolled": _db.increment(-1),
          'enrollments': _db.arrayRemove([EnrollmentsMapper.toMap(enrollment)])
        },
        groupId,
      );

  @override
  Future<int> getGroupsCountForResearch(String researchId) async {
    return await _db
        .getQuery(DatabaseQuery([Where('researchId', isEqualTo: researchId)]))
        .then((groups) => groups.length);
  }

  @override
  Future<Enrollment> getParticipantEnrollment(
    String participantId,
    String researchId,
  ) async {
    return await _db
        .getQuery(DatabaseQuery(
          [
            Where('enrollmentsIds', arrayContains: participantId),
            Where('researchId', isEqualTo: researchId),
          ],
        ))
        .then((groups) =>
            groups.isNotEmpty ? _getEnrollmentFromGroups(groups, participantId) : throw Exception("Not Found"));
  }

  Enrollment _getEnrollmentFromGroups(
    List<Group> groups,
    String participantId,
  ) {
    try {
      return groups.firstWhere((g) => g.getParticipantIndex(participantId) != -1).getEnrollment(participantId);
    } catch (e) {
      throw Exception("NotFound");
    }
  }

  @override
  Future<void> updateEnrollment(String researchId, Enrollment enrollment) async {
    final group = await getGroup(enrollment.groupId);

    await updateGroup(group.updateEnrollment(enrollment));
  }

  @override
  Future<void> markRedeemed(Enrollment enrollment) async {
    final group = await getGroup(enrollment.groupId);

    await updateGroup(group.markEnrollmentRedeemed(enrollment));
  }
}

final groupsRepoPvdr = Provider<GroupsRepository>(
  (ref) => GroupsRepositoryImpl(
    remoteDatabase: FirestoreRemoteDatabase<Group, void>(
      db: ref.read(databasePvdr),
      collectionPath: 'groups',
      fromMap: ((snapshot, _) => snapshot.data() == null
          ? Group.empty()
          : GroupsMapper.fromMap(
              snapshot.data()!,
            )),
      toMap: (group, _) => GroupsMapper.toMap(group),
    ),
  ),
);
