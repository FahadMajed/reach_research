import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveMeeting extends UseCase<void, Meeting> {
  final ResearchsRepository repository;
  RemoveMeeting(this.repository);

  @override
  Future<void> call(meeting) async => repository.removeMeeting(
        meeting,
      );
}

final removeMeetingPvdr = Provider<RemoveMeeting>(
  (ref) => RemoveMeeting(
    ref.read(researchsRepoPvdr),
  ),
);
