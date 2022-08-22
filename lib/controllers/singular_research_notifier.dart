import 'package:flutter/material.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

mixin SingularResearchNotifier on BaseResearchNotifier {
  SingularResearch get singularResearch => state as SingularResearch;
  List<Enrollment> get enrollments => singularResearch.enrollments;

  void _updateEnrollments(Enrollment enrollment) => updateState(enrollments: [
        for (final e in enrollments)
          if (e.participant.participantId ==
              enrollment.participant.participantId)
            enrollment
          else
            e
      ]);

  void _addEnrollment(Enrollment enrollment) =>
      updateState(enrollments: [...enrollments, enrollment]);
  @protected
  void addParticipantToSingle(Participant participant) {
    _addEnrollment(
      Enrollment(
        participant: participant,
        status: EnrollmentStatus.enrolled,
        benefits: [],
        groupId: '',
        redeemed: false,
      ),
    );
  }

  @protected
  void kickParticipantFromEnrollments(String participantId) => updateState(
      enrollments: singularResearch.enrollments
        ..removeWhere((enrollment) =>
            enrollment.participant.participantId == participantId));

  @protected
  void addSingularUnifiedBenefit(Benefit benefit) {
    for (final enrollment in enrollments) {
      bool alreadyInserted = false;
      for (final b in enrollment.benefits) {
        if (b.benefitName == benefit.benefitName) alreadyInserted = true;
      }

      if (alreadyInserted) {
        enrollment.benefits
            .removeWhere((b) => b.benefitName == benefit.benefitName);
      }
      enrollment.benefits.add(benefit);
      _updateEnrollments(enrollment);
    }
  }

  @protected
  void addSingularUniqueBenefit(
    Enrollment enrollment,
    Benefit benefitToInsert,
  ) {
    bool alreadyInserted = false;

    for (final benefit in enrollment.benefits) {
      if (benefit.benefitName == benefitToInsert.benefitName) {
        alreadyInserted = true;
      }
    }
    int partIndex = singularResearch.getParticipantIndex(
      enrollment.participant.participantId,
    );
    if (alreadyInserted) {
      singularResearch.removeBenefit(
        partIndex,
        benefitToInsert.benefitName,
      );
    }

    final updatedEnrollment = enrollments[partIndex]
      ..benefits.add(benefitToInsert);

    _updateEnrollments(updatedEnrollment);
  }
}
