import 'package:reach_research/constants/constants.dart';

import 'criterion.dart';

class ValueCriterion extends Criterion {
  final String condition;

  const ValueCriterion({
    required this.condition,
    required String name,
  }) : super(name: name);

  const ValueCriterion.gender({
    required this.condition,
  }) : super(name: "gender");

  const ValueCriterion.nation({
    required this.condition,
  }) : super(name: "nation");

  bool get isNotDetermined => condition.isEmpty;

  bool get isMale => condition == "Male";

  ValueCriterion copyWith({String? condition}) {
    return ValueCriterion(
      condition: condition ?? this.condition,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {'condition': condition, 'name': name};
  }

  factory ValueCriterion.fromMap(Map<String, dynamic> map) {
    return ValueCriterion(condition: map['condition'] ?? "", name: map['name']);
  }

  @override
  String toString() => '(name: $name, condition: $condition)';

  bool isNotEqualsTo(ValueCriterion researchCriterion) =>
      condition != researchCriterion.condition && condition.isNotEmpty;

  @override
  List<Object?> get props => [condition];

  ValueCriterion updateCondition(int selectedConditionIndex) => copyWith(
        condition: selectedConditionIndex == 0 ? "" : criterionPickerList[name]![selectedConditionIndex],
      );
}
