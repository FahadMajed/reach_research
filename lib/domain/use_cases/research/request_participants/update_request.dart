import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class UpdateParticipantsRequest
    extends UseCase<Research, UpdateParticipantsRequestParams> {
  final ResearchsRepository repository;
  UpdateParticipantsRequest(this.repository);

  @override
  Future<Research> call(UpdateParticipantsRequestParams params) async {
    final updatedResearch = copyResearchWith(
      params.research,
      requestedParticipantsNumber: params.newNumber,
    );

    return await repository
        .updateData(updatedResearch, updatedResearch.researchId)
        .then((_) => updatedResearch);
  }
}

class UpdateParticipantsRequestParams {
  final Research research;
  final int newNumber;

  UpdateParticipantsRequestParams({
    required this.research,
    required this.newNumber,
  });
}

final updateParticipantsRequestPvdr =
    Provider<UpdateParticipantsRequest>((ref) => UpdateParticipantsRequest(
          ref.read(researchsRepoPvdr),
        ));
