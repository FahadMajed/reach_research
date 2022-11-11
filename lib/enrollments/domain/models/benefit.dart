import 'package:reach_core/lib.dart';

class Benefit extends Equatable {
  final String benefitName;
  final String description;
  final String place;

  final String benefitValue;
  final BenefitType type;

  // if it is not unique, all parts will have the same benefit. e.g. coupon code.

  const Benefit({
    required this.benefitName,
    required this.description,
    required this.type,
    this.benefitValue = "",
    this.place = "",
  });
  factory Benefit.empty() => Benefit(benefitName: "", description: "", type: BenefitType.values[0], place: "");

  Benefit copyWith({
    String? benefitName,
    String? place,
    String? description,
    String? benefit,
    BenefitType? type,
  }) {
    return Benefit(
      benefitName: benefitName ?? this.benefitName,
      description: description ?? this.description,
      place: place ?? this.place,
      type: type ?? this.type,
      benefitValue: benefit ?? benefitValue,
    );
  }

  @override
  List<Object?> get props => [
        benefitName,
        benefitValue,
        description,
        place,
        type,
      ];
}

enum BenefitType {
  unified,
  unique,
  cash,
}
