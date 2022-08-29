import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddResearch extends UseCase<Research, AddResearchParams> {
  final ResearchsRepository researchsRepository;
  final ResearcherRepository researcherRepository;

  AddResearch(this.researchsRepository, this.researcherRepository);

  @override
  Future<Research> call(AddResearchParams params) async {
    final research = params.research;

    await researcherRepository.addResearch(
      research.researcher.researcherId,
      research.researchId,
    );

    return await researchsRepository
        .create(research, research.researchId)
        .then((_) => research);
  }
}

class AddResearchParams {
  final Research research;

  AddResearchParams({required this.research});
}
