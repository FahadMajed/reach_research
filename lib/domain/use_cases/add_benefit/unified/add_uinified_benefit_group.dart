import 'package:reach_research/domain/use_cases/add_benefit/unified/add_unified_benefit.dart';
import 'package:reach_research/research.dart';

class AddUnifiedGroupBeneftit
    extends AddUnifiedBenefit<List<Group>, AddUnifiedGroupBenefitParams> {
  final GroupsRepository repository;

  AddUnifiedGroupBeneftit(this.repository);

  @override
  Future<List<Group>> call(AddUnifiedGroupBenefitParams params) async {
    final _groups = params.groups;
    final _benefitToInsert = params.benefit;
    final groupsAfterUpdate = <Group>[];

    for (final group in _groups) {
      for (final enrollment in group.enrollments) {
        bool alreadyInserted = false;
        for (final benefit in enrollment.benefits) {
          if (benefit.benefitName == _benefitToInsert.benefitName) {
            alreadyInserted = true;
          }
        }

        if (alreadyInserted) {
          enrollment.removeBenefit(_benefitToInsert.benefitName);
        }

        enrollment.benefits.add(_benefitToInsert);
      }

      await repository
          .updateGroup(group)
          .then((_) => groupsAfterUpdate.add(group));
    }
    return groupsAfterUpdate;
  }
}

class AddUnifiedGroupBenefitParams extends AddUnifiedBenefitsParams {
  final List<Group> groups;

  AddUnifiedGroupBenefitParams({
    required this.groups,
    required super.benefit,
  });
}
