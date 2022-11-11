import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddUnifiedBenefitForEnrollments
    extends AddUnifiedBenefit<List<Enrollment>, AddUnifiedBenefitForEnrollmentsRequest> {
  final EnrollmentsRepository repository;

  AddUnifiedBenefitForEnrollments(this.repository);

  @override
  Future<List<Enrollment>> call(AddUnifiedBenefitForEnrollmentsRequest request) async {
    final enrollments = request.enrollments;
    final benefitToInsert = request.benefit;
    final enrollmentsAfterUpdate = <Enrollment>[];

    for (final enrollment in enrollments) {
      enrollmentsAfterUpdate.add(enrollment.addBenefit(benefitToInsert));
    }
    for (final e in enrollmentsAfterUpdate) {
      repository.updateEnrollment(e);
    }
    return enrollmentsAfterUpdate;
  }
}

class AddUnifiedBenefitForEnrollmentsRequest extends AddUnifiedBenefitsRequest {
  final List<Enrollment> enrollments;

  AddUnifiedBenefitForEnrollmentsRequest({
    required super.benefit,
    required this.enrollments,
  });
}

abstract class AddUnifiedBenefit<T, P> extends UseCase<T, P> {}

abstract class AddUnifiedBenefitsRequest {
  final Benefit benefit;

  AddUnifiedBenefitsRequest({
    required this.benefit,
  });
}

final addUnifiedBenefitForEnrollmentsPvdr =
    Provider<AddUnifiedBenefitForEnrollments>((ref) => AddUnifiedBenefitForEnrollments(
          ref.read(enrollmentsRepoPvdr),
        ));
