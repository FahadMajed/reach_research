import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddResearch extends UseCase<Research, AddResearchParams> {
  final ResearchsRepository researchsRepository;
  final ResearcherRepository researcherRepository;

  AddResearch(this.researchsRepository, this.researcherRepository);

  @override
  Future<Research> call(AddResearchParams params) async {
    final research = params.research;

    researcherRepository.addResearch(
      research.researcher.researcherId,
      research.researchId,
    );

    researchsRepository.create(
      research,
      research.researchId,
    );
    return research;
  }
}

class AddResearchParams {
  final Research research;

  AddResearchParams({required this.research});
}

final addResearchPvdr = Provider<AddResearch>((ref) => AddResearch(
      ref.read(researchsRepoPvdr),
      ref.read(researcherRepoPvdr),
    ));
