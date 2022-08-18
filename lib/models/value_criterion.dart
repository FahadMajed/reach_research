import 'criterion.dart';

class ValueCriterion extends Criterion {
  final String condition;

  ValueCriterion({
    required this.condition,
    required String name,
  }) : super(name: name);

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ValueCriterion && other.condition == condition;
  }

  @override
  int get hashCode => condition.hashCode;
}
