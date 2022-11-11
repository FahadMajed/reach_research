import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class KickParticipant extends UseCase<Research, KickParticipantRequest> {
  final ResearchsRepository researchsRepository;
  final ChatsRepository chatsRepository;

  final ParticipantsRepository participantsRepository;

  KickParticipant({
    required this.researchsRepository,
    required this.chatsRepository,
    required this.participantsRepository,
  });
  late KickParticipantRequest _request;

  Research get _research => _request.research;
  String get _participantId => _request.participantId;
  @override
  Future<Research> call(KickParticipantRequest request) async {
    _request = request;

    final updatedResearch = _research.kickParticipant(_participantId);

    _removeResearchIdFromPeerChat();
    _removeResearchIdFromParticipantEnrollments();

    researchsRepository.updateResearch(updatedResearch);
    return updatedResearch;
  }

  Future<void> _removeResearchIdFromPeerChat() async {
    chatsRepository.removeResearchIdFromPeerChat(
      Formatter.formatChatId(
        _research.researcherId,
        _participantId,
      ),
      _research.researchId,
    );
  }

  Future<void> _removeResearchIdFromParticipantEnrollments() async {
    participantsRepository.removeEnrollment(
      _participantId,
      _research.researchId,
    );
  }
}

class KickParticipantRequest {
  final String participantId;
  final Research research;

  KickParticipantRequest({
    required this.participantId,
    required this.research,
  });
}

final kickParticipantPvdr = Provider<KickParticipant>((ref) => KickParticipant(
      researchsRepository: ref.read(researchsRepoPvdr),
      chatsRepository: ref.read(chatsRepoPvdr),
      participantsRepository: ref.read(partsRepoPvdr),
    ));
