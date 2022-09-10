import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';
import 'package:reach_research/enrollments/domain/use_cases/enrollments.dart';

class AddUnifiedGroupBenefit
    extends AddUnifiedBenefit<List<Group>, AddUnifiedGroupBenefitParams> {
  final GroupsRepository repository;

  AddUnifiedGroupBenefit(this.repository);

  @override
  Future<List<Group>> call(AddUnifiedGroupBenefitParams params) async {
    final _groups = params.groups;
    final _benefitToInsert = params.benefit;
    final groupsAfterUpdate = <Group>[];

    for (var group in _groups) {
      for (final enrollment in group.enrollments) {
        group = group.addBenefit(enrollment.id, _benefitToInsert);
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

final addUnifiedGroupBenefitPvdr =
    Provider<AddUnifiedGroupBenefit>((ref) => AddUnifiedGroupBenefit(
          ref.read(groupsRepoPvdr),
        ));
