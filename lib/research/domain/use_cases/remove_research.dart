import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveResearch extends UseCase<void, RemoveResearchRequest> {
  final ResearchsRepository researchsRepository;
  final ResearchersRepository researcherRepository;
  final ParticipantsRepository participantsRepository;

  RemoveResearch({
    required this.researchsRepository,
    required this.researcherRepository,
    required this.participantsRepository,
  });

  @override
  Future<void> call(RemoveResearchRequest request) async {
    final researchId = request.researchId;
    final enrolledIds = request.enrolledIds;
    final researcherId = request.researcherId;

    await researchsRepository.removeResearch(researchId);
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

class RemoveResearchRequest {
  String researchId;
  List enrolledIds;
  String researcherId;

  RemoveResearchRequest({
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
