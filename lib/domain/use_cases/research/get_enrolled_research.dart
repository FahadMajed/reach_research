import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetEnrolledResearch
    extends UseCase<Research?, GetEnrolledResearchParams> {
  final ResearchsRepository repository;

  GetEnrolledResearch(this.repository);

  @override
  Future<Research?> call(GetEnrolledResearchParams params) async =>
      await repository.getEnrolledResearch(params.participantId);
}

class GetEnrolledResearchParams {
  final String participantId;
  GetEnrolledResearchParams({
    required this.participantId,
  });
}

final getEnrolledResearchPvdr =
    Provider<GetEnrolledResearch>((ref) => GetEnrolledResearch(
          ref.read(researchsRepoPvdr),
        ));
