import 'package:reach_research/data/repositories/enrollments_repository.dart';
import 'package:reach_research/domain/use_cases/add_benefit/unified/unified.dart';
import 'package:reach_research/research.dart';

class AddUnifiedBenefitForEnrollments extends AddUnifiedBenefit<
    List<Enrollment>, AddUnifiedBenefitForEnrollmentsParams> {
  final EnrollmentsRepository repository;

  AddUnifiedBenefitForEnrollments(this.repository);

  @override
  Future<List<Enrollment>> call(
      AddUnifiedBenefitForEnrollmentsParams params) async {
    final enrollments = params.enrollments;
    final benefitToInsert = params.benefit;
    final enrollmentsAfterUpdate = <Enrollment>[];

    for (final enrollment in enrollments) {
      bool alreadyInserted = false;
      for (final b in enrollment.benefits) {
        if (b.benefitName == benefitToInsert.benefitName) {
          alreadyInserted = true;
        }
      }

      if (alreadyInserted) {
        enrollment.benefits
            .removeWhere((b) => b.benefitName == benefitToInsert.benefitName);
      }
      enrollment.benefits.add(benefitToInsert);
      enrollmentsAfterUpdate.add(enrollment);
    }
    for (final e in enrollmentsAfterUpdate) {
      await repository.updateEnrollment(e);
    }
    return enrollmentsAfterUpdate;
  }
}

class AddUnifiedBenefitForEnrollmentsParams extends AddUnifiedBenefitsParams {
  final List<Enrollment> enrollments;

  AddUnifiedBenefitForEnrollmentsParams({
    required super.benefit,
    required this.enrollments,
  });
}
