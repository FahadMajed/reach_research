import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class StartResearch extends UseCase<Research, StartResearchParams> {
  final ResearchsRepository researchsRepository;
  final ChatsRepository chatsRepository;

  StartResearch({
    required this.researchsRepository,
    required this.chatsRepository,
  });
  @override
  Future<Research> call(StartResearchParams params) async {
    final updatedResearch = copyResearchWith(
      params.research,
      phases: params.phases,
      researchState: ResearchState.ongoing,
    );

    for (final id in params.enrollmentsResearcherChattedIds ?? []) {
      await chatsRepository.addResearchIdToPeerChat(
        Formatter.formatChatId(updatedResearch.researcher.researcherId, id),
        updatedResearch.researchId,
      );
    }
    return await researchsRepository
        .updateData(updatedResearch, updatedResearch.researchId)
        .then((_) => updatedResearch);
  }
}

class StartResearchParams {
  final List<Phase> phases;
  final Research research;
  final List? enrollmentsResearcherChattedIds;

  StartResearchParams({
    required this.phases,
    required this.research,
    this.enrollmentsResearcherChattedIds,
  });
}

final startResearchPvdr = Provider<StartResearch>((ref) => StartResearch(
      researchsRepository: ref.read(researchsRepoPvdr),
      chatsRepository: ref.read(chatsRepoPvdr),
    ));
