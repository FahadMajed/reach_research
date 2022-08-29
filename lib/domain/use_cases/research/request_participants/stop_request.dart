import 'package:reach_research/research.dart';

class StopRequest extends UseCase<Research, StopRequestParams> {
  final ResearchsRepository repository;
  StopRequest(this.repository);
  @override
  Future<Research> call(StopRequestParams params) async {
    final updatedResearch = copyResearchWith(
      params.research,
      isRequestingParticipants: false,
      sampleSize: params.research.numberOfEnrolled,
      requestedParticipantsNumber: 0,
      requestJoiners: 0,
    );

    return await repository
        .updateData(
          updatedResearch,
          updatedResearch.researchId,
        )
        .then((_) => updatedResearch);
  }
}

class StopRequestParams {
  final Research research;
  StopRequestParams({required this.research});
}
