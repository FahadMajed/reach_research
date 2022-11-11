import 'package:reach_core/lib.dart';

class Phase extends Equatable {
  final String title;
  final String description;
  final String phaseHint;
  final String descriptionHint;

  final bool isChecked;
  final String? date;

  const Phase({
    this.title = "",
    this.description = "",
    this.isChecked = false,
    this.phaseHint = "",
    this.descriptionHint = "",
    this.date,
  });

  Phase copyWith({
    String? title,
    String? description,
    String? phaseHint,
    String? descriptionHint,
    bool? isChecked,
    String? date,
  }) {
    return Phase(
      title: title ?? this.title,
      description: description ?? this.description,
      phaseHint: phaseHint ?? this.phaseHint,
      descriptionHint: descriptionHint ?? this.descriptionHint,
      isChecked: isChecked ?? this.isChecked,
      date: date ?? this.date,
    );
  }

  factory Phase.empty() => const Phase(title: "", description: "", isChecked: false, date: "Date");

  @override
  List<Object?> get props => [
        title,
        description,
        phaseHint,
        descriptionHint,
        isChecked,
        date,
      ];
}
