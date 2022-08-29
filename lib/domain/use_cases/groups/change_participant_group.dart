import 'package:reach_research/research.dart';

class ChangeParticipantGroup
    extends UseCase<List<Group>, ChangeParticipantGroupParams> {
  final GroupsRepository repository;

  ChangeParticipantGroup(this.repository);

  @override
  Future<List<Group>> call(params) async {
    final _groups = params.groups;
    final fromIndex = params.fromIndex;
    final toIndex = params.toIndex;
    final participantIndex = params.participantIndex;

    final Enrollment participantToChange =
        _groups[fromIndex].enrollments[participantIndex];

    _groups[fromIndex].enrollments.remove(participantToChange);
    _groups[toIndex].enrollments.add(participantToChange);

    await repository.updateGroup(_groups[fromIndex]);
    await repository.updateGroup(_groups[toIndex]);

    return _groups;
  }
}

class ChangeParticipantGroupParams {
  final List<Group> groups;
  final int fromIndex;
  final int toIndex;
  final int participantIndex;

  ChangeParticipantGroupParams({
    required this.groups,
    required this.fromIndex,
    required this.toIndex,
    required this.participantIndex,
  });
}
