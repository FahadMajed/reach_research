import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateMeeting extends UseCase<void, Meeting> {
  final ResearchsRepository repository;
  UpdateMeeting(this.repository);

  @override
  Future<void> call(meeting) async {
    repository.updateMeeting(meeting);
  }
}

final updateMeetingPvdr = Provider<UpdateMeeting>((ref) => UpdateMeeting(
      ref.read(researchsRepoPvdr),
    ));
