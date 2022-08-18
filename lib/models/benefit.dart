class Benefit {
  final String benefitName;
  final String value;
  final String place;

  final BenefitType type;

  // if it is not unique, all parts will have the same benefit. e.g. coupon code.

  Benefit({
    required this.benefitName,
    required this.value,
    required this.type,
    this.place = "",
  });

  toMap() {
    return {
      'benefitName': benefitName,
      'value': value,
      'type': type.index,
      "place": place
    };
  }

  factory Benefit.fromMap(map) {
    return Benefit(
        benefitName: map['benefitName'] ?? "",
        value: map['value'] ?? "",
        type: BenefitType.values[map['type'] ?? 0],
        place: map["place"] ?? "");
  }

  factory Benefit.empty() => Benefit(
      benefitName: "", value: "", type: BenefitType.values[0], place: "");

  @override
  String toString() {
    return 'Benefit(benefitName: $benefitName, value: $value, place: $place, type: $type)';
  }

  Benefit copyWith({
    String? benefitName,
    String? value,
    String? place,
    BenefitType? type,
  }) {
    return Benefit(
      benefitName: benefitName ?? this.benefitName,
      value: value ?? this.value,
      place: place ?? this.place,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Benefit &&
        other.benefitName == benefitName &&
        other.value == value &&
        other.place == place &&
        other.type == type;
  }

  @override
  int get hashCode {
    return benefitName.hashCode ^
        value.hashCode ^
        place.hashCode ^
        type.hashCode;
  }
}

enum BenefitType {
  Unified,
  Unique,
  Cash,
}
