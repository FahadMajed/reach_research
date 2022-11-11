import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddEmptyGroup extends UseCase<Group, AddEmptyGroupRequest> {
  final GroupsRepository repository;

  AddEmptyGroup(
    this.repository,
  );

  @override
  Future<Group> call(request) async {
    final groupsLength = request.groupsLength;

    final emptyGroup = Group(
      enrollmentsIds: [],
      researchId: request.researchId,
      groupId: Formatter.formatGroupId(
        title: request.researchTitle,
        number: groupsLength + 1,
      ),
      groupNumber: groupsLength + 1,
      enrollments: [],
    );

    repository.addGroup(emptyGroup);
    return emptyGroup;
  }
}

class AddEmptyGroupRequest {
  final String researchId;
  final int groupsLength;
  final String researchTitle;

  AddEmptyGroupRequest({
    required this.researchId,
    required this.groupsLength,
    required this.researchTitle,
  });
}

final addEmptyGroupPvdr = Provider<AddEmptyGroup>((ref) => AddEmptyGroup(
      ref.read(groupsRepoPvdr),
    ));
