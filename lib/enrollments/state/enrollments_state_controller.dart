import 'package:reach_core/lib.dart';
import 'package:reach_research/research.dart';

class EnrollmentsStateController extends AsyncListStateController<Enrollment> {
  final Reader read;
  late final GetEnrollments _getEnrollments;

  EnrollmentsStateController(this.read) {
    _getEnrollments = read(getEnrollmentsPvdr);
    if (mounted) {
      getEnrollmentsForResearch();
    }
  }

  Future<void> getEnrollmentsForResearch() async {
    emitLoading();

    await _getEnrollments.call(_researchId).then(
          (enrollments) => emitData(enrollments),
          onError: (e) => emitError(e),
        );
  }

  String get _researchId => read(researchStateCtrlPvdr).researchId;

  List<Enrollment> get enrollments => list;

  Enrollment getEnrollmentByParticipantId(String participantId) {
    return enrollments.firstWhere((e) => e.partId == participantId);
  }
}
