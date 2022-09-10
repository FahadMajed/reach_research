import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GroupsRemoteDatabase extends RemoteDatabase<Group, void> {
  GroupsRemoteDatabase({
    required super.db,
    required super.collectionPath,
    required super.fromMap,
    required super.toMap,
  });

  Future<void> addEnrollmentToGroup(
    String groupId,
    Enrollment enrollment,
  ) async =>
      await updateDocumentRaw(
        {
          "numberOfEnrolled": FieldValue.increment(1),
          'enrollments': FieldValue.arrayUnion([enrollment.toMap()])
        },
        groupId,
      );

  Future<void> removeEnrollmentFromGroup(
    String groupId,
    Enrollment enrollment,
  ) async =>
      await updateDocumentRaw(
        {
          "numberOfEnrolled": FieldValue.increment(-1),
          'enrollments': FieldValue.arrayRemove([enrollment.toMap()])
        },
        groupId,
      );
}
