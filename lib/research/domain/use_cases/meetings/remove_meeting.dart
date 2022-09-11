import 'package:reach_core/core/core.dart';
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

final removeMeetingPvdr = Provider<RemoveMeeting>((ref) => RemoveMeeting(
      ref.read(researchsRepoPvdr),
    ));
