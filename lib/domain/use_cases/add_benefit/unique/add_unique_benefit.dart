import 'package:reach_research/research.dart';

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
