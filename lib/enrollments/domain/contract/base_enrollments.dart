import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

abstract class EnrollmentsRepository {
  Future<void> addEnrollment(Enrollment enrollment);

  Future<Enrollment> getEnrollment(String id);

  Future<void> updateEnrollment(
    Enrollment enrollment,
  );

  Future<void> removeEnrollment(Enrollment enrollment);

  Future<List<Enrollment>> getEnrollments(String researchId);

  Future<Enrollment> getParticipantEnrollment(String participantId);

  Future<void> updateParticipant(
    String researchId,
    Participant participant,
  );
}
