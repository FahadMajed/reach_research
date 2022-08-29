import 'package:reach_research/research.dart';

class KickParticipant extends UseCase<Research, KickParticipantParams> {
  final ResearchsRepository repository;

  KickParticipant(this.repository);
  @override
  Future<Research> call(KickParticipantParams params) async {
    final partId = params.participantId;
    final research = params.research;

    final updatedResearch = copyResearchWith(
      research,
      numberOfEnrolled: research.numberOfEnrolled - 1,
      enrolledIds: research.enrolledIds..remove(partId),
    );
//unsubscriping from topic will be handled to the server
    return await repository
        .updateData(updatedResearch, updatedResearch.researchId)
        .then((_) => updatedResearch);
  }
}

class KickParticipantParams {
  final String participantId;
  final Research research;

  KickParticipantParams({
    required this.participantId,
    required this.research,
  });
}
