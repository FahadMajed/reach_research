import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrollmentsNotifier extends StateNotifier<AsyncValue<List<Enrollment>>> {
  EnrollmentsNotifier({
    required this.research,
    required this.addParticipantToEnrollments,
    required this.addUniqueBenefit,
    required this.addUnifiedBenefit,
    required this.kickParticipantFromEnrollments,
    required this.getEnrollments,
  }) : super(const AsyncLoading()) {
    if (research.researchId.isNotEmpty) getEnrollmentsForResearch();
  }

  final SingularResearch research;

  final GetEnrollments getEnrollments;

  final AddParticipantToEnrollments addParticipantToEnrollments;

  final KickParticipantFromEnrollments kickParticipantFromEnrollments;

  final AddUniqueBenefitForEnrollment addUniqueBenefit;
  final AddUnifiedBenefitForEnrollments addUnifiedBenefit;

  List<Enrollment> get enrollments => state.value ?? [];

  Future<void> getEnrollmentsForResearch() async {
    state = const AsyncLoading();
    await getEnrollments
        .call(GetEnrollmentsParams(
          researchId: research.researchId,
        ))
        .then(
          (enrollments) => state = AsyncData(enrollments),
          onError: (e) => state = AsyncError(e),
        );
  }

  Future<void> addParticipant(Participant participant) async =>
      addParticipantToEnrollments
          .call(AddParticipantParams(
            participant: participant,
            researchId: research.researchId,
          ))
          .then(
            (enrollment) => _addEnrollment(enrollment),
            onError: (e) => state = AsyncError(e),
          );

  Future<void> kickParticipant(Enrollment enrollment) async =>
      await kickParticipantFromEnrollments
          .call(KickParticipantFromEnrollmentsParams(
            enrollment: enrollment,
            researcherId: research.researcher.researcherId,
          ))
          .then(
            (enrollment) => _removeEnrollment(enrollment),
            onError: (e) => state = AsyncError(e),
          );

  Future<void> addEnrollmentsUnifiedBenefit(Benefit benefit) async =>
      await addUnifiedBenefit
          .call(AddUnifiedBenefitForEnrollmentsParams(
            benefit: benefit,
            enrollments: enrollments,
          ))
          .then(
            (enrollments) => state = AsyncData(enrollments),
            onError: (e) => state = AsyncError(e),
          );

  Future<void> addEnrollmentsUniqueBenefit(
    Enrollment enrollment,
    Benefit benefitToInsert,
  ) async =>
      await addUniqueBenefit
          .call(AddUniqueBenefitParams(
            benefit: benefitToInsert,
            enrollment: enrollment,
          ))
          .then(
            (enrollment) => _updateEnrollments(enrollment),
            onError: (e) => state = AsyncError(e),
          );

  void _addEnrollment(Enrollment enrollment) => state = AsyncData(
        [
          ...enrollments,
          enrollment,
        ],
      );

  void _updateEnrollments(Enrollment enrollment) {
    final enrollments = List<Enrollment>.from(state.value!);

    state = AsyncData(
      [
        for (final e in enrollments)
          if (e.participant.participantId ==
              enrollment.participant.participantId)
            enrollment
          else
            e
      ],
    );
  }

  void _removeEnrollment(Enrollment enrollment) => state =
      AsyncData(enrollments..removeWhere((e) => e.partId == enrollment.partId));
}
