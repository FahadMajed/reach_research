import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetGroupsForResearch extends UseCase<List<Group>, String> {
  final GroupsRepository repository;

  GetGroupsForResearch(this.repository);

  @override
  Future<List<Group>> call(researchId) async =>
      await repository.getGroupsForResearch(researchId);
}

final getGroupsPvdr = Provider<GetGroupsForResearch>(
    (ref) => GetGroupsForResearch(ref.read(groupsRepoPvdr)));
