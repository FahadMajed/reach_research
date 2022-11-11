import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class AddResearch extends UseCase<Research, Research> {
  final ResearchsRepository researchsRepository;
  final ResearchersRepository researcherRepository;

  AddResearch(this.researchsRepository, this.researcherRepository);

  @override
  Future<Research> call(research) async {
    researcherRepository.addResearch(
      research.researcher.researcherId,
      research.researchId,
    );

    researchsRepository.addResearch(research);
    return research;
  }
}

final addResearchPvdr = Provider<AddResearch>((ref) => AddResearch(
      ref.read(researchsRepoPvdr),
      ref.read(researcherRepoPvdr),
    ));
