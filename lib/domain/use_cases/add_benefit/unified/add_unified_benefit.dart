import 'package:reach_research/domain/domain.dart';

abstract class AddUnifiedBenefit<T, P> extends UseCase<T, P> {}

abstract class AddUnifiedBenefitsParams {
  final Benefit benefit;

  AddUnifiedBenefitsParams({
    required this.benefit,
  });
}
