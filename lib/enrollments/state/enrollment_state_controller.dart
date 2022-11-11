import 'package:reach_auth/reach_auth.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class EnrollmentStateController extends AsyncStateControIIer<Enrollment> {
  late final GetEnrollment _getEnrollment;

  late final String _userId;
  EnrollmentStateController(read, AsyncValue<Participant?> participant) {
    _getEnrollment = read(getEnrollmentPvdr);
    _userId = read(userIdPvdr);

    participant.whenData((participant) => participant != null ? getEnrollment(participant) : null);
  }

  Future<void> getEnrollment(Participant participant) async => participant.currentEnrollments.isNotEmpty
      ? await _getEnrollment.call(participant).then(
            (enrollment) => emitData(enrollment),
            onError: (e) => throw e,
          )
      : null;

  Enrollment get enrollment => state.value!;
}

final enrollmentStatePvdr = StateNotifierProvider<EnrollmentStateController, AsyncValue<Enrollment>>(
    (ref) => EnrollmentStateController(ref.read, ref.watch(partStatePvdr)));

final enrollmentStateCtrlPvdr = Provider((ref) => ref.watch(enrollmentStatePvdr.notifier));
