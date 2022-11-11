import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddEnrollment extends UseCase<Enrollment, AddEnrollmentRequest> {
  AddEnrollment(this.repository);

  final EnrollmentsRepository repository;

  @override
  Future<Enrollment> call(AddEnrollmentRequest request) async {
    final enrollment = Enrollment.create(
      request.participant,
      researchId: request.researchId,
    );
    repository.addEnrollment(enrollment);
    return enrollment;
  }
}

class AddEnrollmentRequest {
  final Participant participant;
  final String? researchId;
  AddEnrollmentRequest({
    required this.participant,
    this.researchId = "",
  });
}

final addEnrollmentPvdr = Provider((ref) => AddEnrollment(
      ref.read(enrollmentsRepoPvdr),
    ));
