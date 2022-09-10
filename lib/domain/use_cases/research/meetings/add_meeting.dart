import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddMeeting extends UseCase<Meeting, AddMeetingParams> {
  final ResearchsRepository repository;
  AddMeeting(this.repository);

  @override
  Future<Meeting> call(AddMeetingParams params) async =>
      await repository.addMeeting(params.researchId, params.meeting).then(
            (meeting) => meeting,
          );
}

class AddMeetingParams {
  final Meeting meeting;
  final String researchId;

  AddMeetingParams({
    required this.meeting,
    required this.researchId,
  });
}

final addMeetingPvdr = Provider<AddMeeting>((ref) => AddMeeting(
      ref.read(researchsRepoPvdr),
    ));
