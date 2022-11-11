import 'package:reach_core/core/core.dart';

abstract class Criterion extends Equatable {
  final String name;

  const Criterion({required this.name});
}
