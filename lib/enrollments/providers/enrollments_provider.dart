import 'package:reach_chats/chats.dart';
import 'package:reach_core/core/core.dart';

import 'package:reach_research/research.dart';

final enrollmentsPvdr =
    StateNotifierProvider<EnrollmentsNotifier, AsyncValue<List<Enrollment>>>(
  (ref) {
    final enrollmentsRepo = ref.read(enrollmentsRepoPvdr);
    final research = ref.watch(researchPvdr).value ?? Research.empty();
    final chatsRepo = ref.read(chatsRepoPvdr);
    final partsRepo = ref.read(partsRepoPvdr);

    return EnrollmentsNotifier(
      research: research as SingularResearch,
      addParticipantToEnrollments: AddParticipantToEnrollments(
        enrollmentsRepo,
      ),
      addUniqueBenefit: AddUniqueBenefitForEnrollment(enrollmentsRepo),
      addUnifiedBenefit: AddUnifiedBenefitForEnrollments(enrollmentsRepo),
      kickParticipantFromEnrollments: KickParticipantFromEnrollments(
        enrollmentsRepository: enrollmentsRepo,
        chatsRepository: chatsRepo,
        participantsRepository: partsRepo,
      ),
      getEnrollments: GetEnrollments(enrollmentsRepo),
    );
  },
);
