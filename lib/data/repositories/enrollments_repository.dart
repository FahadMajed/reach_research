import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrollmentsRepository extends BaseRepository<Enrollment, void> {
  EnrollmentsRepository({required super.remoteDatabase});

  Future<void> addEnrollment(Enrollment enrollment) async =>
      await create(enrollment, _getDocId(enrollment));

  Future<void> updateEnrollment(
    Enrollment enrollment,
  ) async =>
      await updateData(
        enrollment,
        _getDocId(enrollment),
      );

  Future<void> removeEnrollment(Enrollment enrollment) async =>
      delete(_getDocId(enrollment));

  String _getDocId(Enrollment enrollment) =>
      enrollment.id + enrollment.researchId!;

  Future<List<Enrollment>> getEnrollments(String researchId) async =>
      await getQuery(remoteDatabase.where('researchId', isEqualTo: researchId));
}

final enrollmentsRepoPvdr = Provider(
  (ref) => EnrollmentsRepository(
    remoteDatabase: RemoteDatabase(
      db: ref.read(databasePvdr),
      collectionPath: 'enrollments',
      fromMap: ((snapshot, _) => snapshot.data() != null
          ? Enrollment.fromMap(snapshot.data()!)
          : Enrollment.empty()),
      toMap: (object, _) => object.toMap(),
    ),
  ),
);
