import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddEmptyGroup extends UseCase<Group, AddEmptyGroupParams> {
  final GroupsRepository repository;
  final ResearchsRepository researchsRepository;
  AddEmptyGroup(
    this.repository,
    this.researchsRepository,
  );

  @override
  Future<Group> call(params) async {
    final timeStamp = Formatter.formatTimeId();
    final groupsLength = params.groupsLength;

    final emptyGroup = Group(
      researchId: params.researchId,
      groupId:
          "Group ${groupsLength + 1} - ${params.researchTitle} - $timeStamp",
      groupName: "Group ${groupsLength + 1}",
      enrollments: const [],
    );
    researchsRepository.incrementGroupsLength(params.researchId);

    return await repository.addGroup(emptyGroup).then((_) => emptyGroup);
  }
}

class AddEmptyGroupParams {
  final String researchId;
  final int groupsLength;
  final String researchTitle;

  AddEmptyGroupParams({
    required this.researchId,
    required this.groupsLength,
    required this.researchTitle,
  });
}

final addEmptyGroupPvdr = Provider<AddEmptyGroup>((ref) =>
    AddEmptyGroup(ref.read(groupsRepoPvdr), ref.read(researchsRepoPvdr)));
