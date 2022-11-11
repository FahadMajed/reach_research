import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateParticipantsRequest extends UseCase<Research, UpdateParticipantsRequestRequest> {
  final ResearchsRepository repository;
  UpdateParticipantsRequest(this.repository);

  @override
  Future<Research> call(UpdateParticipantsRequestRequest request) async {
    final research = request.research;
    final updatedResearch = copyResearchWith(
      research,
      partsRequest: research.partsRequest.copyWith(
        numberOfRequested: request.newNumber,
      ),
      sampleSize: research.numberOfEnrolled + request.newNumber,
    );
    repository.updateResearch(updatedResearch);
    return updatedResearch;
  }
}

class UpdateParticipantsRequestRequest {
  final Research research;
  final int newNumber;

  UpdateParticipantsRequestRequest({
    required this.research,
    required this.newNumber,
  });
}

final updateParticipantsRequestPvdr = Provider<UpdateParticipantsRequest>((ref) => UpdateParticipantsRequest(
      ref.read(researchsRepoPvdr),
    ));
