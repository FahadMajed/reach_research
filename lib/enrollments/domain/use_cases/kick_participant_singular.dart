import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';

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
      Formatter.formatChatId(params.researcherId, enrollment.partId),
      enrollment.researchId!,
    );

    await participantsRepository.removeEnrollment(
      enrollment.partId,
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

final kickParticipantFromEnrollmentsPvdr =
    Provider<KickParticipantFromEnrollments>(
        (ref) => KickParticipantFromEnrollments(
              enrollmentsRepository: ref.read(enrollmentsRepoPvdr),
              chatsRepository: ref.read(chatsRepoPvdr),
              participantsRepository: ref.read(partsRepoPvdr),
            ));
