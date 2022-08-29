import 'package:reach_core/core/data/repositories/notifications_repository.dart';
import 'package:reach_research/research.dart';

class KickParticipant extends UseCase<Research, KickParticipantParams> {
  final ResearchsRepository repository;
  final NotificationsRepository? notificationsRepo;
  KickParticipant(this.repository, this.notificationsRepo);
  @override
  Future<Research> call(KickParticipantParams params) async {
    final partId = params.participantId;
    final research = params.research;

    final updatedResearch = copyResearchWith(
      research,
      numberOfEnrolled: research.numberOfEnrolled - 1,
      enrolledIds: research.enrolledIds..remove(partId),
    );
    await notificationsRepo
        ?.unsubscribeFromResearch(updatedResearch.researchId);

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
