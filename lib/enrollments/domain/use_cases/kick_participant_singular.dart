import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class KickParticipantFromEnrollments extends UseCase<void, Enrollment> {
  final EnrollmentsRepository enrollmentsRepository;

  KickParticipantFromEnrollments({
    required this.enrollmentsRepository,
  });
  @override
  Future<void> call(Enrollment enrollment) async {
    enrollmentsRepository.removeEnrollment(enrollment);
  }
}

final kickParticipantFromEnrollmentsPvdr =
    Provider<KickParticipantFromEnrollments>((ref) => KickParticipantFromEnrollments(
          enrollmentsRepository: ref.read(enrollmentsRepoPvdr),
        ));
