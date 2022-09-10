import 'package:reach_core/core/core.dart';
import 'package:reach_research/enrollments/domain/use_cases/enrollments.dart';
import 'package:reach_research/research.dart';

class AddUniqueGroupBenefit
    extends AddUniqueBenefit<Group, AddUniqueGroupBenefitsParams> {
  final GroupsRepository repository;

  AddUniqueGroupBenefit(this.repository);

  @override
  Future<Group> call(AddUniqueGroupBenefitsParams params) async {
    Group _group = params.group;
    final enrollmentId = params.enrollment.id;
    final benefitToInsert = params.benefit;

    _group = _group.addBenefit(enrollmentId, benefitToInsert);

    return await repository.updateGroup(_group).then((_) => _group);
  }
}

class AddUniqueGroupBenefitsParams extends AddUniqueBenefitParams {
  final Group group;

  AddUniqueGroupBenefitsParams({
    required super.benefit,
    required this.group,
    required super.enrollment,
  });
}

final addUniqueGroupBenefitPvdr = Provider<AddUniqueGroupBenefit>(
    (ref) => AddUniqueGroupBenefit(ref.read(groupsRepoPvdr)));
