import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveParticipants extends UseCase<Research, RemoveParticipantsParams> {
  final ResearchsRepository repository;

  RemoveParticipants(
    this.repository,
  );

  @override
  Future<Research> call(RemoveParticipantsParams params) async {
    final research = params.research;
    final toRemoveIds = params.toRemoveIds;
    final updatedResearch = copyResearchWith(
      research,
      enrolledIds: research.enrolledIds
        ..removeWhere((id) => toRemoveIds.contains(id)),
      numberOfEnrolled: research.numberOfEnrolled - toRemoveIds.length,
    );

    return await repository
        .updateData(updatedResearch, updatedResearch.researchId)
        .then((_) => updatedResearch);
  }
}

class RemoveParticipantsParams {
  final Research research;
  final List toRemoveIds;

  RemoveParticipantsParams({
    required this.research,
    required this.toRemoveIds,
  });
}

final removeParticipantsPvdr =
    Provider<RemoveParticipants>((ref) => RemoveParticipants(
          ref.read(researchsRepoPvdr),
        ));
