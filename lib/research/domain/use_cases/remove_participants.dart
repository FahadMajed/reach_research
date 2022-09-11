import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RemoveParticipants extends UseCase<void, RemoveParticipantsParams> {
  final ResearchsRepository repository;

  RemoveParticipants(
    this.repository,
  );

  @override
  Future<void> call(RemoveParticipantsParams params) async {
    return await repository.removeParticipants(
      params.researchId,
      params.toRemoveIds,
    );
  }
}

class RemoveParticipantsParams {
  final String researchId;

  final List toRemoveIds;

  RemoveParticipantsParams({
    required this.researchId,
    required this.toRemoveIds,
  });
}

final removeParticipantsPvdr =
    Provider<RemoveParticipants>((ref) => RemoveParticipants(
          ref.read(researchsRepoPvdr),
        ));
