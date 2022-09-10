import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EndResearch extends UseCase<void, EndResearchParams> {
  final ResearchsRepository researchsRepository;
  final ResearcherRepository researcherRepository;

  EndResearch({
    required this.researcherRepository,
    required this.researchsRepository,
  });
  @override
  Future<void> call(EndResearchParams params) async {
    final updatedResearch = copyResearchWith(
      params.research,
      researchState: ResearchState.redeeming,
    );

    await researcherRepository.endResearch(
      updatedResearch.researcher.researcherId,
      updatedResearch.researchId,
    );

    await researchsRepository.updateData(
      updatedResearch,
      updatedResearch.researchId,
    );
  }
}

class EndResearchParams {
  final Research research;

  EndResearchParams({
    required this.research,
  });
}

final endResearchPvdr = Provider<EndResearch>((ref) => EndResearch(
    researchsRepository: ref.read(researchsRepoPvdr),
    researcherRepository: ref.read(researcherRepoPvdr)));
