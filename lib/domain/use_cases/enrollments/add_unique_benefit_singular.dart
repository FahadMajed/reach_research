import 'package:reach_research/data/repositories/enrollments_repository.dart';
import 'package:reach_research/research.dart';

class AddUniqueBenefitForEnrollment
    extends AddUniqueBenefit<Enrollment, AddUniqueBenefitParams> {
  final EnrollmentsRepository repository;

  AddUniqueBenefitForEnrollment(this.repository);

  @override
  Future<Enrollment> call(AddUniqueBenefitParams params) async {
    Enrollment enrollment = params.enrollment;
    final Benefit benefitToInsert = params.benefit;

    enrollment = enrollment.addBenefit(benefitToInsert);

    return await repository
        .updateEnrollment(enrollment)
        .then((_) => enrollment);
  }
}

abstract class AddUniqueBenefit<T, AddUniqueBenefitsParams>
    extends UseCase<T, AddUniqueBenefitsParams> {}

class AddUniqueBenefitParams {
  final Enrollment enrollment;
  final Benefit benefit;

  AddUniqueBenefitParams({
    required this.enrollment,
    required this.benefit,
  });
}
