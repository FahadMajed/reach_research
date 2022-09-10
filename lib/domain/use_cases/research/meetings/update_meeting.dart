import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateMeeting extends UseCase<Meeting, UpdateMeetingParams> {
  final ResearchsRepository repository;
  UpdateMeeting(this.repository);

  @override
  Future<Meeting> call(UpdateMeetingParams params) async =>
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

final updateMeetingPvdr = Provider<UpdateMeeting>((ref) => UpdateMeeting(
      ref.read(researchsRepoPvdr),
    ));
