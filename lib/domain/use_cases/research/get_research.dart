import 'package:reach_research/research.dart';

class GetResearch extends UseCase<Research, GetResearchParams> {
  final ResearchsRepository repository;

  GetResearch(this.repository);

  @override
  Future<Research> call(GetResearchParams params) async =>
      await repository.getResearch(params.researcherId);
}

class GetResearchParams {
  final String researcherId;

  GetResearchParams({
    required this.researcherId,
  });
}
