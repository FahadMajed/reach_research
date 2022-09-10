import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/data/repositories/notifications_repository.dart';
import 'package:reach_research/research.dart';

class AddParticipantToResearch
    extends UseCase<Research, AddParticipantToResearchParams> {
  AddParticipantToResearch(
    this.repository,
    this.participantRepository,
    this.chatsRepository,
    this.addParticipantToGroup,
    this.addParticipantToEnrollments,
    this.notificationsRepo,
  );

  @override
  Future<Research> call(AddParticipantToResearchParams params) async {
    _params = params;
    Research research = params.research;

    int numberOfEnrolled = research.numberOfEnrolled;
    int requestJoiners = research.requestJoiners;
    bool isRequestingParticipants = research.isRequestingParticipants;

    if (researchIsFull) {
      throw ResearchIsFull();
    }

    numberOfEnrolled++;

    research = copyResearchWith(research,
        numberOfEnrolled: numberOfEnrolled,
        enrolledIds: [...research.enrolledIds, partId]);

    await notificationsRepo?.subscribeToResearch(researchId);

    await participantRepository.addEnrollment(
      partId,
      researchId,
    );

    if (research is GroupResearch) {
      bool newGroupIsAdded = false;
      newGroupIsAdded = await addParticipantToGroup(
        AddParticipantToGroupParams(
          participant: participant,
          groupResearch: research,
        ),
      );

      if (newGroupIsAdded) {
        research =
            copyResearchWith(research, groupsLength: research.groupsLength + 1);
      }
    }

    if (research is SingularResearch) {
      await addParticipantToEnrollments(
        AddParticipantParams(
          participant: participant,
          researchId: research.researchId,
        ),
      );
    }

    if (research.researchState == ResearchState.ongoing) {
      await chatsRepository.addResearchIdToPeerChat(
        Formatter.formatChatId(
          researcherId,
          partId,
        ),
        researchId,
      );
    }

    if (isRequestingParticipants) {
      requestJoiners++;
      research = copyResearchWith(research, requestJoiners: requestJoiners);

      if (research.requestedParticipantsNumber == requestJoiners) {
        //STOP REQUEST
        research = copyResearchWith(
          research,
          isRequestingParticipants: false,
          requestJoiners: 0,
          requestedParticipantsNumber: 0,
        );
        return await repository
            .updateData(
              research,
              researchId,
            )
            .then((_) => research);
      }
    }
    return await repository
        .updateData(
          research,
          researchId,
        )
        .then((_) => research);
  }

  final ResearchsRepository repository;
  final ParticipantsRepository participantRepository;
  final ChatsRepository chatsRepository;
  final AddParticipantToGroup addParticipantToGroup;
  final AddParticipantToEnrollments addParticipantToEnrollments;
  final NotificationsRepository? notificationsRepo;

  late AddParticipantToResearchParams _params;

  Participant get participant => _params.participant;
  Research get _research => _params.research;
  String get researcherId => _research.researcher.researcherId;
  String get partId => _params.participant.participantId;
  String get researchId => _research.researchId;

  bool get researchIsFull =>
      _params.research.sampleSize == _params.research.numberOfEnrolled;
}

class AddParticipantToResearchParams {
  final Participant participant;
  final Research research;

  AddParticipantToResearchParams({
    required this.participant,
    required this.research,
  });
}

final addParticipantToResearchPvdr =
    Provider<AddParticipantToResearch>((ref) => AddParticipantToResearch(
          ref.read(researchsRepoPvdr),
          ref.read(partsRepoPvdr),
          ref.read(chatsRepoPvdr),
          ref.read(addParticipantToGroupPvdr),
          ref.read(addParticipantToEnrollmentsPvdr),
          ref.read(notificationsRepoPvdr),
        ));
