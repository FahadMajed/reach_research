import 'package:reach_research/research.dart';

class UpdateMeeting extends UseCase<void, UpdateMeetingParams> {
  final ResearchsRepository repository;
  UpdateMeeting(this.repository);

  @override
  Future<void> call(UpdateMeetingParams params) async =>
      await repository.updateMeeting(params.researchId, params.meeting).then(
            (meeting) => params.meeting,
          );
}

class UpdateMeetingParams {
  final Meeting meeting;
  final String researchId;

  UpdateMeetingParams({
    required this.meeting,
    required this.researchId,
  });
}
