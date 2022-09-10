import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetResearch extends UseCase<Research?, GetResearchParams> {
  final ResearchsRepository repository;

  GetResearch(this.repository);

  @override
  Future<Research?> call(GetResearchParams params) async =>
      await repository.getResearch(params.researcherId).then(
            (research) => research,
            onError: (e) => e is ResearchNotFound ? null : throw e,
          );
}

class GetResearchParams {
  final String researcherId;

  GetResearchParams({
    required this.researcherId,
  });
}

final getResearchPvdr = Provider<GetResearch>((ref) => GetResearch(
      ref.read(researchsRepoPvdr),
    ));
