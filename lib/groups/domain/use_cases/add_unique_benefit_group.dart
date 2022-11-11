import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddUniqueGroupBenefit extends AddUniqueBenefit<Group, AddUniqueGroupBenefitsRequest> {
  final GroupsRepository repository;

  AddUniqueGroupBenefit(this.repository);

  @override
  Future<Group> call(AddUniqueGroupBenefitsRequest request) async {
    Group _group = request.group;
    final enrollmentId = request.enrollment.id;
    final benefitToInsert = request.benefit;

    _group = _group.addBenefit(enrollmentId, benefitToInsert);

    repository.updateGroup(_group);

    return _group;
  }
}

class AddUniqueGroupBenefitsRequest extends AddUniqueBenefitRequest {
  final Group group;

  AddUniqueGroupBenefitsRequest({
    required super.benefit,
    required this.group,
    required super.enrollment,
  });
}

final addUniqueGroupBenefitPvdr =
    Provider<AddUniqueGroupBenefit>((ref) => AddUniqueGroupBenefit(ref.read(groupsRepoPvdr)));
