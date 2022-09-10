import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetGroupsForResearch
    extends UseCase<List<Group>, GetGroupsForResearchParams> {
  final GroupsRepository repository;

  GetGroupsForResearch(this.repository);

  @override
  Future<List<Group>> call(params) async =>
      await repository.getGroupsForResearch(params.researchId);
}

class GetGroupsForResearchParams {
  final String researchId;

  GetGroupsForResearchParams({
    required this.researchId,
  });
}

final getGroupsPvdr = Provider<GetGroupsForResearch>(
    (ref) => GetGroupsForResearch(ref.read(groupsRepoPvdr)));
