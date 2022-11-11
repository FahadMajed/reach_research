import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class StartResearch extends UseCase<Research, StartResearchRequest> {
  final ResearchsRepository researchsRepository;
  final ChatsRepository chatsRepository;

  StartResearch({
    required this.researchsRepository,
    required this.chatsRepository,
  });

  late StartResearchRequest _request;
  Research get _research => _request.research;
  String get _researcherId => _research.researcherId;
  String get _researchId => _research.researchId;
  List? get _enrollmentsResearcherChattedIds => _request.enrollmentsResearcherChattedIds;

  @override
  Future<Research> call(StartResearchRequest request) async {
    _request = request;
    _addResearchIdToPeerChats();

    final updatedResearch = _research.start(request.phases);

    researchsRepository.updateResearch(updatedResearch);

    return updatedResearch;
  }

  Future<void> _addResearchIdToPeerChats() async {
    for (final id in _enrollmentsResearcherChattedIds ?? []) {
      chatsRepository.addResearchIdToPeerChat(
        Formatter.formatChatId(_researcherId, id),
        _researchId,
      );
    }
  }
}

class StartResearchRequest {
  final List<Phase> phases;
  final Research research;

  final List? enrollmentsResearcherChattedIds;
  StartResearchRequest({
    required this.phases,
    required this.research,
    this.enrollmentsResearcherChattedIds,
  });
}

final startResearchPvdr = Provider<StartResearch>((ref) => StartResearch(
      researchsRepository: ref.read(researchsRepoPvdr),
      chatsRepository: ref.read(chatsRepoPvdr),
    ));
