import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/data/repositories/notifications_repository.dart';
import 'package:reach_research/research.dart';

class AddParticipantToResearch
    extends UseCase<Research, AddParticipantToResearchParams> {
  final ResearchsRepository repository;
  final ParticipantsRepository participantRepository;
  final AddParticipantToGroup addParticipantToGroup;
  final AddParticipantToEnrollments addParticipantToEnrollments;
  final NotificationsRepository? notificationsRepo;

  AddParticipantToResearch(
    this.repository,
    this.participantRepository,
    this.addParticipantToGroup,
    this.addParticipantToEnrollments,
    this.notificationsRepo,
  );

  @override
  Future<Research> call(AddParticipantToResearchParams params) async {
    Research research = params.research;
    final participant = params.participant;

    int numberOfEnrolled = research.numberOfEnrolled;
    int requestJoiners = research.requestJoiners;
    bool isRequestingParticipants = research.isRequestingParticipants;

    if (research.sampleSize == research.numberOfEnrolled) {
      throw ResearchIsFull();
    }

    numberOfEnrolled++;

    research = copyResearchWith(research,
        numberOfEnrolled: numberOfEnrolled,
        enrolledIds: [...research.enrolledIds, participant.participantId]);

    if (isRequestingParticipants) {
      requestJoiners++;
      research = copyResearchWith(research, requestJoiners: requestJoiners);

      if (research.requestedParticipantsNumber == requestJoiners) {
        //STOP REQUEST
        research = copyResearchWith(
          research,
          numberOfEnrolled: numberOfEnrolled,
          isRequestingParticipants: false,
          requestJoiners: 0,
          requestedParticipantsNumber: 0,
        );
        return await repository
            .updateData(research, research.researchId)
            .then((_) => research);
      }
    }

    await notificationsRepo?.subscribeToResearch(research.researchId);

    await participantRepository.addEnrollment(
      participant.participantId,
      research.researchId,
    );

    if (research is GroupResearch) {
      addParticipantToGroup(
        AddParticipantToGroupParams(
          participant: participant,
          groupResearch: research,
        ),
      );
    }

    return await repository
        .updateData(research, research.researchId)
        .then((_) => research);
  }
}

class AddParticipantToResearchParams {
  final Participant participant;
  final Research research;

  AddParticipantToResearchParams({
    required this.participant,
    required this.research,
  });
}
