import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveResearch extends UseCase<void, RemoveResearchParams> {
  final ResearchsRepository researchsRepository;
  final ResearcherRepository researcherRepository;
  final ParticipantsRepository participantsRepository;

  RemoveResearch({
    required this.researchsRepository,
    required this.researcherRepository,
    required this.participantsRepository,
  });

  @override
  Future<void> call(RemoveResearchParams params) async {
    final researchId = params.researchId;
    final enrolledIds = params.enrolledIds;
    final researcherId = params.researcherId;

    await researchsRepository.delete(researchId);
    for (final partId in enrolledIds) {
      await participantsRepository.removeEnrollment(
        partId,
        researchId,
      );
    }
    await researcherRepository.removeResearch(
      researcherId,
      researchId,
    );
  }
}

class RemoveResearchParams {
  String researchId;
  List enrolledIds;
  String researcherId;

  RemoveResearchParams({
    required this.researchId,
    required this.enrolledIds,
    required this.researcherId,
  });
}

final removeResearchPvdr = Provider<RemoveResearch>((ref) => RemoveResearch(
      researchsRepository: ref.read(researchsRepoPvdr),
      researcherRepository: ref.read(researcherRepoPvdr),
      participantsRepository: ref.read(partsRepoPvdr),
    ));
