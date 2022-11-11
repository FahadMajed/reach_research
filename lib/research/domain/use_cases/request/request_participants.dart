import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RequestParticipants extends UseCase<Research, RequestParticipantsRequest> {
  final ResearchsRepository repository;
  RequestParticipants(this.repository);

  @override
  Future<Research> call(RequestParticipantsRequest request) async {
    final research = request.research;
    final numberOfRequested = request.numberOfRequested;
    final updatedResearch = research.startParticipantsRequest(numberOfRequested);
    repository.updateResearch(updatedResearch);

    return updatedResearch;
  }
}

class RequestParticipantsRequest {
  final int numberOfRequested;
  final Research research;

  RequestParticipantsRequest({
    required this.numberOfRequested,
    required this.research,
  });
}

final requestParticipantsPvdr = Provider<RequestParticipants>((ref) => RequestParticipants(
      ref.read(researchsRepoPvdr),
    ));
