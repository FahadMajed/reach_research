import 'dart:developer';

import 'package:reach_research/data/repositories/enrollments_repository.dart';
import 'package:reach_research/domain/models/models.dart';
import 'package:reach_research/domain/use_cases/use_cases.dart';

class AddParticipantToEnrollments
    extends UseCase<Enrollment, AddParticipantParams> {
  AddParticipantToEnrollments(this.repository);

  final EnrollmentsRepository repository;

  @override
  Future<Enrollment> call(AddParticipantParams params) async {
    log(params.researchId ?? "RESEARCH ID IS NULL");
    final enrollment = Enrollment(
      participant: params.participant,
      status: EnrollmentStatus.enrolled,
      benefits: [],
      groupId: '',
      redeemed: false,
      researchId: params.researchId,
    );
    return await repository.addEnrollment(enrollment).then((_) => enrollment);
  }
}
