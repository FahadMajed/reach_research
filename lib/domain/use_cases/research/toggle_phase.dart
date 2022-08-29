import 'package:reach_research/research.dart';

class TogglePhase extends UseCase<Research, TogglePhaseParams> {
  final ResearchsRepository repository;

  TogglePhase(this.repository);

  @override
  Future<Research> call(TogglePhaseParams params) async {
    final research = params.research;

    final updatedResearch = copyResearchWith(
      research,
      phases: [
        for (final p in research.phases)
          if (research.phases.indexOf(p) == params.phaseIndex)
            p.copyWith(isChecked: !p.isChecked)
          else
            p,
      ],
    );

    return await repository
        .updateData(updatedResearch, updatedResearch.researchId)
        .then((_) => updatedResearch);
  }
}

class TogglePhaseParams {
  final Research research;
  final int phaseIndex;

  TogglePhaseParams({
    required this.research,
    required this.phaseIndex,
  });
}
