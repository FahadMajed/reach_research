import 'package:reach_research/data/repositories/enrollments_repository.dart';
import 'package:reach_research/research.dart';

class AddUniqueBenefitForEnrollment
    extends AddUniqueBenefit<Enrollment, AddUniqueBenefitParams> {
  final EnrollmentsRepository repository;

  AddUniqueBenefitForEnrollment(this.repository);

  @override
  Future<Enrollment> call(AddUniqueBenefitParams params) async {
    final enrollment = params.enrollment;
    final Benefit benefitToInsert = params.benefit;

    bool alreadyInserted = false;

    for (final benefit in enrollment.benefits) {
      if (benefit.benefitName == benefitToInsert.benefitName) {
        alreadyInserted = true;
      }
    }

    if (alreadyInserted) {
      enrollment.removeBenefit(
        benefitToInsert.benefitName,
      );
    }

    final updatedEnrollment = enrollment..benefits.add(benefitToInsert);

    return await repository
        .updateEnrollment(enrollment)
        .then((_) => updatedEnrollment);
  }
}
