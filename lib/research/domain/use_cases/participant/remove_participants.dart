import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveParticipants extends UseCase<Research, RemoveParticipantsRequest> {
  final ResearchsRepository repository;

  RemoveParticipants(
    this.repository,
  );

  @override
  Future<Research> call(RemoveParticipantsRequest request) async {
    final updatedResearch = request.research.removeParticipants(request.toRemoveIds);
    repository.updateResearch(updatedResearch);

    return updatedResearch;
  }
}

class RemoveParticipantsRequest {
  final Research research;

  final List toRemoveIds;

  RemoveParticipantsRequest({
    required this.research,
    required this.toRemoveIds,
  });
}

final removeParticipantsPvdr = Provider<RemoveParticipants>((ref) => RemoveParticipants(
      ref.read(researchsRepoPvdr),
    ));
