import 'package:reach_core/core/core.dart';
import 'package:reach_research/research/research.dart';

class GetMeetings extends UseCase<List<Meeting>, GetMeetingsParams> {
  final ResearchsRepository repository;
  GetMeetings(this.repository);
  @override
  Future<List<Meeting>> call(GetMeetingsParams params) async =>
      await repository.getMeetings(params.researchId);
}

class GetMeetingsParams {
  final String researchId;
  GetMeetingsParams({
    required this.researchId,
  });
}

final getMeetingsPvdr = Provider<GetMeetings>((ref) => GetMeetings(
      ref.read(researchsRepoPvdr),
    ));
