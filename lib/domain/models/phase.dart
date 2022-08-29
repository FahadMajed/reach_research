class Phase {
  final String title;
  final String description;
  final String phaseHint;
  final String descriptionHint;

  final bool isChecked;
  final String? date;

  Phase({
    this.title = "",
    this.description = "",
    this.isChecked = false,
    this.phaseHint = "",
    this.descriptionHint = "",
    this.date,
  });

  factory Phase.fromFirestore(Map data) {
    return Phase(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isChecked: data['isChecked'] ?? false,
        date: data['date']);
  }

  @override
  String toString() {
    return 'Phase(title: $title, description: $description, phaseHint: $phaseHint, descriptionHint: $descriptionHint, isChecked: $isChecked, date: $date)';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      "isChecked": isChecked,
      'date': date,
    };
  }

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Phase &&
        other.title == title &&
        other.description == description &&
        other.phaseHint == phaseHint &&
        other.descriptionHint == descriptionHint &&
        other.isChecked == isChecked &&
        other.date == date;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        description.hashCode ^
        phaseHint.hashCode ^
        descriptionHint.hashCode ^
        isChecked.hashCode ^
        date.hashCode;
  }
}
