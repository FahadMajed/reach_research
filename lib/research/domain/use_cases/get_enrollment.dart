import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class GetEnrollment extends UseCase<Enrollment, Participant> {
  final ResearchsRepository repository;
  final EnrollmentsRepository enrollmentsRepository;
  final GroupsRepository groupsRepository;
  GetEnrollment(
    this.repository,
    this.enrollmentsRepository,
    this.groupsRepository,
  );

  @override
  Future<Enrollment> call(participant) async {
    late Enrollment enrollment;
    final researchId = participant.currentEnrollments.first;
    try {
      enrollment = await enrollmentsRepository.getParticipantEnrollment(participant.participantId);
    } catch (e) {
      enrollment = await groupsRepository.getParticipantEnrollment(participant.participantId, researchId);
    }
    final research = await repository.getEnrolledResearch(participant.participantId);

    return enrollment.copyWith(
      research: research,
      researchId: research!.researchId,
    );
  }
}

final getEnrollmentPvdr = Provider<GetEnrollment>((ref) => GetEnrollment(
      ref.read(researchsRepoPvdr),
      ref.read(enrollmentsRepoPvdr),
      ref.read(groupsRepoPvdr),
    ));
