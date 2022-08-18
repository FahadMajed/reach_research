import 'criterion.dart';

class RangeCriterion extends Criterion {
  final int from;
  final int to;

  RangeCriterion({
    required this.from,
    required this.to,
    required String name,
  }) : super(name: name);

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
    return {'from': from, 'to': to, 'name': name};
  }

  factory RangeCriterion.fromMap(Map<String, dynamic> map) {
    return RangeCriterion(
      from: map['from']?.toInt() ?? 0,
      to: map['to']?.toInt() ?? 0,
      name: map['name'] ?? "",
    );
  }

  @override
  String toString() => '(from: $from, to: $to)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeCriterion && other.from == from && other.to == to;
  }

  @override
  int get hashCode => from.hashCode ^ to.hashCode;
}
