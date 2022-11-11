import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrollmentsRepositoryImpl implements EnrollmentsRepository {
  EnrollmentsRepositoryImpl({required RemoteDatabase<Enrollment, void> remoteDatabase}) {
    _db = remoteDatabase;
  }

  late final RemoteDatabase<Enrollment, void> _db;

  @override
  Future<void> addEnrollment(Enrollment enrollment) async => await _db.createDocument(enrollment, enrollment.id);

  @override
  Future<Enrollment> getEnrollment(String id) async => await _db.getDocument(id);

  @override
  Future<void> updateEnrollment(
    Enrollment enrollment,
  ) async =>
      await _db.updateDocument(
        enrollment,
        enrollment.id,
      );

  @override
  Future<void> removeEnrollment(Enrollment enrollment) async => _db.deleteDocument(enrollment.id);

  @override
  Future<List<Enrollment>> getEnrollments(String researchId) async => await _db.getQuery(
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
  Future<Enrollment> getParticipantEnrollment(String participantId) async => await _db
      .getQuery(
        DatabaseQuery(
          [
            Where(
              'participant.participantId',
              isEqualTo: participantId,
            ),
            Where(
              'redeemed',
              isEqualTo: false,
            )
          ],
        ),
      )
      .then((query) => query.isNotEmpty ? query.first : throw Exception("Not Found"));

  @override
  Future<void> updateParticipant(
    String researchId,
    Participant participant,
  ) async {
    await _db.updateField(participant.participantId + researchId, 'participant', ParticipantMapper.toMap(participant));
  }
}

final enrollmentsRepoPvdr = Provider<EnrollmentsRepository>(
  (ref) => EnrollmentsRepositoryImpl(
    remoteDatabase: FirestoreRemoteDatabase<Enrollment, void>(
      db: ref.read(databasePvdr),
      collectionPath: 'enrollments',
      fromMap: ((snapshot, _) =>
          snapshot.data() != null ? EnrollmentsMapper.fromMap(snapshot.data()!) : Enrollment.empty()),
      toMap: (e, _) => EnrollmentsMapper.toMap(e),
    ),
  ),
);
