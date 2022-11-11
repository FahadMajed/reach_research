import 'criterion.dart';

class RangeCriterion extends Criterion {
  final int from;
  final int to;

  const RangeCriterion({
    required this.from,
    required this.to,
    required String name,
  }) : super(name: name);

  const RangeCriterion.age({
    required this.from,
    required this.to,
  }) : super(name: "age");

  const RangeCriterion.height({
    required this.from,
    required this.to,
  }) : super(name: "height");
  const RangeCriterion.weight({
    required this.from,
    required this.to,
  }) : super(name: "weight");
  const RangeCriterion.income({
    required this.from,
    required this.to,
  }) : super(name: "income");

  RangeCriterion copyWith({
    int? from,
    int? to,
  }) {
    return RangeCriterion(
      from: from ?? this.from,
      to: to ?? this.to,
      name: name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'name': name,
    };
  }

  factory RangeCriterion.fromMap(Map<String, dynamic> map) {
    return RangeCriterion(
      from: map['from']?.toInt() ?? 0,
      to: map['to']?.toInt() ?? 0,
      name: map['name'] ?? "",
    );
  }

  String get asRange => "${from.toString()} - ${to.toString()}";

  bool isInRange(RangeCriterion reserachCriterion) {
    return (from >= reserachCriterion.from && to <= reserachCriterion.to);
  }

  ///compares [this] with other criterion, and update [this]
  ///if it is wider (e.g. 22-25) than other (e.g. 24-26)
  ///result: (24-25)
  RangeCriterion compareTo(RangeCriterion researchCriterion) {
    int newFrom = 0;
    int newTo = 0;
    if (_fromIsLessThan(researchCriterion.from)) {
      newFrom = researchCriterion.from;
    }
    if (_toIsGreaterThan(researchCriterion.to)) {
      newTo = researchCriterion.to;
    }

    return copyWith(
      from: newFrom == 0 ? from : newFrom,
      to: newTo == 0 ? to : newTo,
    );
  }

  bool _fromIsLessThan(int researchFrom) {
    return from < researchFrom;
  }

  bool _toIsGreaterThan(int researchTo) {
    return to > researchTo;
  }

  bool isOutOfRange(RangeCriterion researchCriterion) {
    if (_rangeIsAfter(researchCriterion)) {
      return true;
    } else if (_rangeIsBefore(researchCriterion)) {
      return true;
    }
    return false;
  }

  bool _rangeIsBefore(RangeCriterion researchCriterion) => to < researchCriterion.from;

  bool _rangeIsAfter(RangeCriterion researchCriterion) => from > researchCriterion.to;

  @override
  List<Object?> get props => [from, to, name];

  RangeCriterion updateRange(int from, int to) => copyWith(
        from: from,
        to: to,
      );
}
