import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrollmentsRepository extends BaseRepository<Enrollment, void> {
  EnrollmentsRepository({required super.remoteDatabase});

  Future<void> addEnrollment(Enrollment enrollment) async =>
      await create(enrollment, enrollment.id);

  Future<void> updateEnrollment(
    Enrollment enrollment,
  ) async =>
      await updateData(
        enrollment,
        enrollment.id,
      );

  Future<void> removeEnrollment(Enrollment enrollment) async =>
      delete(enrollment.id);

  Future<List<Enrollment>> getEnrollments(String researchId) async =>
      await getQuery(where('researchId', isEqualTo: researchId));

  Future<void> updateParticipant(
    String enrollmentId,
    Participant participant,
  ) async {
    await updateField(enrollmentId, 'participant', participant.toPartialMap());
  }
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
