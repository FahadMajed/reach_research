import 'package:reach_research/research.dart';

class RemoveMeeting extends UseCase<void, RemoveMeetingParams> {
  final ResearchsRepository repository;
  RemoveMeeting(this.repository);

  @override
  Future<void> call(RemoveMeetingParams params) async =>
      await repository.removeMeeting(params.researchId, params.meeting);
}

class RemoveMeetingParams {
  final Meeting meeting;
  final String researchId;

  RemoveMeetingParams({
    required this.meeting,
    required this.researchId,
  });
}
