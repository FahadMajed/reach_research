import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddUniqueBenefitForEnrollment extends AddUniqueBenefit<Enrollment, AddUniqueBenefitRequest> {
  final EnrollmentsRepository repository;

  AddUniqueBenefitForEnrollment(this.repository);

  @override
  Future<Enrollment> call(AddUniqueBenefitRequest request) async {
    Enrollment enrollment = request.enrollment;
    final Benefit benefitToInsert = request.benefit;

    enrollment = enrollment.addBenefit(benefitToInsert);

    repository.updateEnrollment(enrollment);
    return enrollment;
  }
}

abstract class AddUniqueBenefit<T, AddUniqueBenefitsRequest> extends UseCase<T, AddUniqueBenefitsRequest> {}

class AddUniqueBenefitRequest {
  final Enrollment enrollment;
  final Benefit benefit;

  AddUniqueBenefitRequest({
    required this.enrollment,
    required this.benefit,
  });
}

final addUniqueBenefitForEnrollmentPvdr =
    Provider<AddUniqueBenefitForEnrollment>((ref) => AddUniqueBenefitForEnrollment(
          ref.read(enrollmentsRepoPvdr),
        ));
