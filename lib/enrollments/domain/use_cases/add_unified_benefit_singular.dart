import 'package:reach_core/core/core.dart';

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
      enrollmentsAfterUpdate.add(enrollment.addBenefit(benefitToInsert));
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

abstract class AddUnifiedBenefit<T, P> extends UseCase<T, P> {}

abstract class AddUnifiedBenefitsParams {
  final Benefit benefit;

  AddUnifiedBenefitsParams({
    required this.benefit,
  });
}

final addUnifiedBenefitForEnrollmentsPvdr =
    Provider<AddUnifiedBenefitForEnrollments>(
        (ref) => AddUnifiedBenefitForEnrollments(
              ref.read(enrollmentsRepoPvdr),
            ));
