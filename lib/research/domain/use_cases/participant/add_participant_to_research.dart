import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddParticipantToResearch extends UseCase<Research, AddParticipantToResearchRequest> {
  AddParticipantToResearch(
    this.repository,
    this.participantRepository,
    this.chatsRepository,
    this.addParticipantToGroup,
    this.addParticipantToEnrollments,
    this.notificationsRepo,
  );

  final ResearchsRepository repository;
  final ParticipantsRepository participantRepository;
  final ChatsRepository chatsRepository;
  final AddParticipantToGroup addParticipantToGroup;
  final AddEnrollment addParticipantToEnrollments;
  final NotificationsRepository? notificationsRepo;

  late AddParticipantToResearchRequest _request;
  late Research _research;

  Participant get _participant => _request.participant;

  String get _researcherId => _research.researcherId;
  String get _partId => _request.participant.participantId;
  String get _researchId => _research.researchId;

  bool get _researchIsNotFull => _request.research.isNotFull;
  @override
  Future<Research> call(AddParticipantToResearchRequest request) async {
    _request = request;
    _research = request.research;

    if (_researchIsNotFull) {
      _research = _research.addEnrollment(_partId);

      _addResearchIdToParticipantChat();

      await _addParticipantToResearch();

      notificationsRepo?.subscribeToResearch(_researchId);

      repository.updateResearch(_research);

      return _research;
    } else {
      throw ResearchIsFull();
    }
  }

  Future<void> _addResearchIdToParticipantChat() async {
    chatsRepository.addResearchIdToPeerChat(
      Formatter.formatChatId(
        _researcherId,
        _partId,
      ),
      _researchId,
    );
  }

  Future<void> _addParticipantToResearch() async {
    participantRepository.addEnrollment(_partId, _researchId);
    if (_research.isGroupResearch) {
      await _addParticipantToGroup();
    } else {
      await _addParticipantToEnrollments();
    }
  }

  Future<void> _addParticipantToGroup() async => addParticipantToGroup.call(AddParticipantToGroupRequest(
        participant: _participant,
        groupResearch: _research as GroupResearch,
      ));

  Future<void> _addParticipantToEnrollments() async => addParticipantToEnrollments.call(AddEnrollmentRequest(
        participant: _participant,
        researchId: _research.researchId,
      ));
}

class AddParticipantToResearchRequest {
  final Participant participant;
  final Research research;

  AddParticipantToResearchRequest({
    required this.participant,
    required this.research,
  });
}

final addParticipantToResearchPvdr = Provider<AddParticipantToResearch>((ref) => AddParticipantToResearch(
      ref.read(researchsRepoPvdr),
      ref.read(partsRepoPvdr),
      ref.read(chatsRepoPvdr),
      ref.read(addParticipantToGroupPvdr),
      ref.read(addEnrollmentPvdr),
      ref.read(notificationsRepoPvdr),
    ));
