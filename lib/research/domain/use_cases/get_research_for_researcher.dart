import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetResearchForResearcher extends UseCase<Research?, String> {
  final ResearchsRepository repository;

  GetResearchForResearcher(this.repository);

  @override
  Future<Research?> call(String researcherId) async =>
      await repository.getResearchForResearcher(researcherId).then(
            (research) => research,
            onError: (e) => e is ResearchNotFound ? null : throw e,
          );
}

final getResearchPvdr =
    Provider<GetResearchForResearcher>((ref) => GetResearchForResearcher(
          ref.read(researchsRepoPvdr),
        ));
