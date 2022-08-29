import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/data/repositories/enrollments_repository.dart';
import 'package:reach_research/research.dart';

class KickParticipantFromEnrollments
    extends UseCase<Enrollment, KickParticipantFromEnrollmentsParams> {
  final EnrollmentsRepository enrollmentsRepository;
  final ChatsRepository chatsRepository;
  final ParticipantsRepository participantsRepository;

  KickParticipantFromEnrollments({
    required this.enrollmentsRepository,
    required this.chatsRepository,
    required this.participantsRepository,
  });
  @override
  Future<Enrollment> call(KickParticipantFromEnrollmentsParams params) async {
    final enrollment = params.enrollment;

    await chatsRepository.removeResearchIdFromChat(
      Formatter.formatChatId(params.researcherId, enrollment.id),
      enrollment.researchId!,
    );

    await participantsRepository.removeCurrentEnrollment(
      enrollment.id,
      enrollment.researchId!,
    );

    return await enrollmentsRepository
        .removeEnrollment(params.enrollment)
        .then((_) => params.enrollment);
  }
}

class KickParticipantFromEnrollmentsParams {
  final Enrollment enrollment;

  final String researcherId;

  KickParticipantFromEnrollmentsParams({
    required this.enrollment,
    required this.researcherId,
  });
}
