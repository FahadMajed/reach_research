import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class TogglePhase extends UseCase<List<Phase>, TogglePhaseRequest> {
  final ResearchsRepository repository;

  TogglePhase(this.repository);

  @override
  Future<List<Phase>> call(TogglePhaseRequest request) async {
    final phases = [
      for (final p in request.phases)
        if (request.phases.indexOf(p) == request.phaseIndex) p.copyWith(isChecked: !p.isChecked) else p,
    ];

    repository.updatePhases(phases, request.researchId);
    return phases;
  }
}

class TogglePhaseRequest {
  final String researchId;
  final List<Phase> phases;
  final int phaseIndex;

  TogglePhaseRequest({
    required this.phases,
    required this.researchId,
    required this.phaseIndex,
  });
}

final togglePhasePvdr = Provider<TogglePhase>((ref) => TogglePhase(
      ref.read(researchsRepoPvdr),
    ));
