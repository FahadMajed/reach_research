import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddMeeting extends UseCase<Meeting, Meeting> {
  final ResearchsRepository repository;
  AddMeeting(this.repository);

  @override
  Future<Meeting> call(meeting) async {
    final m = meeting.copyWith(id: Formatter.formatTimeId());

    repository.addMeeting(m);
    return m;
  }
}

final addMeetingPvdr = Provider<AddMeeting>((ref) => AddMeeting(
      ref.read(researchsRepoPvdr),
    ));
