import 'package:reach_research/research.dart';

class AddUniqueGroupBenefit
    extends AddUniqueBenefit<Group, AddUniqueGroupBenefitsParams> {
  final GroupsRepository repository;

  AddUniqueGroupBenefit(this.repository);

  @override
  Future<Group> call(AddUniqueGroupBenefitsParams params) async {
    final _group = params.group;
    final enrollment = params.enrollment;
    final benefitToInsert = params.benefit;

    int partIndex =
        _group.getParticipantIndex(enrollment.participant.participantId);

    bool alreadyInserted = false;

    for (final benefit in enrollment.benefits) {
      benefit.benefitName == benefitToInsert.benefitName
          ? alreadyInserted = true
          : null;
    }

    if (alreadyInserted) {
      _group.removeBenefit(partIndex, benefitToInsert.benefitName);
    }

    _group.addBenefit(partIndex, benefitToInsert);

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
