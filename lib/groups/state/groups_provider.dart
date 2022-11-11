import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

import 'groups_state_controller.dart';

final groupsStatePvdr =
    StateNotifierProvider<GroupsStateController, AsyncValue<List<Group>?>>(
  (ref) => GroupsStateController(ref.read),
);

final groupsStateCtrlPvdr =
    Provider((ref) => ref.watch(groupsStatePvdr.notifier));
