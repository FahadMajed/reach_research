import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class RequestParticipants extends UseCase<Research, RequestParticipantsParams> {
  final ResearchsRepository repository;
  RequestParticipants(this.repository);

  @override
  Future<Research> call(RequestParticipantsParams params) async {
    final research = params.research;
    final requestedParticipantsNumber = params.requestedParticipantsNumber;
    final updatedResearch = copyResearchWith(
      research,
      isRequestingParticipants: true,
      requestedParticipantsNumber: requestedParticipantsNumber,
      sampleSize: research.numberOfEnrolled + requestedParticipantsNumber,
    );

    return await repository
        .updateData(
            copyResearchWith(
              updatedResearch,
              isRequestingParticipants: true,
              requestedParticipantsNumber: requestedParticipantsNumber,
              sampleSize:
                  research.numberOfEnrolled + requestedParticipantsNumber,
            ),
            research.researchId)
        .then((_) => updatedResearch);
  }
}

class RequestParticipantsParams {
  final int requestedParticipantsNumber;
  final Research research;

  RequestParticipantsParams({
    required this.requestedParticipantsNumber,
    required this.research,
  });
}

final requestParticipantsPvdr =
    Provider<RequestParticipants>((ref) => RequestParticipants(
          ref.read(researchsRepoPvdr),
        ));
