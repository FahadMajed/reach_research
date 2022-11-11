import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

import 'enrollments_state_controller.dart';

final enrollmentsStatePvdr = StateNotifierProvider<EnrollmentsStateController,
    AsyncValue<List<Enrollment>?>>(
  (ref) => EnrollmentsStateController(ref.read),
);

final enrollmentsStateCtrlPvdr =
    Provider((ref) => ref.watch(enrollmentsStatePvdr.notifier));
