import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddUnifiedGroupBenefit extends AddUnifiedBenefit<List<Group>, AddUnifiedGroupBenefitRequest> {
  final GroupsRepository repository;

  AddUnifiedGroupBenefit(this.repository);

  @override
  Future<List<Group>> call(AddUnifiedGroupBenefitRequest request) async {
    final _groups = request.groups;
    final _benefitToInsert = request.benefit;
    final groupsAfterUpdate = <Group>[];

    for (var group in _groups) {
      for (final enrollment in group.enrollments) {
        group = group.addBenefit(enrollment.id, _benefitToInsert);
      }
      groupsAfterUpdate.add(group);

      repository.updateGroup(group);
    }
    return groupsAfterUpdate;
  }
}

class AddUnifiedGroupBenefitRequest extends AddUnifiedBenefitsRequest {
  final List<Group> groups;

  AddUnifiedGroupBenefitRequest({
    required this.groups,
    required super.benefit,
  });
}

final addUnifiedGroupBenefitPvdr = Provider<AddUnifiedGroupBenefit>((ref) => AddUnifiedGroupBenefit(
      ref.read(groupsRepoPvdr),
    ));
