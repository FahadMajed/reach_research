import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class StopRequest extends UseCase<Research, StopRequestRequest> {
  final ResearchsRepository repository;
  StopRequest(this.repository);
  @override
  Future<Research> call(StopRequestRequest request) async {
    final updatedResearch = request.research.stopParticipantsRequest();

    repository.updateResearch(updatedResearch);
    return updatedResearch;
  }
}

class StopRequestRequest {
  final Research research;
  StopRequestRequest({required this.research});
}

final stopRequestPvdr = Provider<StopRequest>((ref) => StopRequest(
      ref.read(researchsRepoPvdr),
    ));
