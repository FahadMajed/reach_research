import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EndResearch extends UseCase<void, EndResearchRequest> {
  final ResearchsRepository researchsRepository;
  final ResearchersRepository researcherRepository;

  EndResearch({
    required this.researcherRepository,
    required this.researchsRepository,
  });
  @override
  Future<void> call(EndResearchRequest request) async {
    researcherRepository.endResearch(
      request.researcherId,
      request.researchId,
    );

    researchsRepository.updateResearchState(
      request.researchId,
      ResearchState.redeeming,
    );
  }
}

class EndResearchRequest {
  final String researchId;
  final String researcherId;

  EndResearchRequest({
    required this.researchId,
    required this.researcherId,
  });
}

final endResearchPvdr = Provider<EndResearch>((ref) =>
    EndResearch(researchsRepository: ref.read(researchsRepoPvdr), researcherRepository: ref.read(researcherRepoPvdr)));
