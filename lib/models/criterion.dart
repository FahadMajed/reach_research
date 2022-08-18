class Criterion {
  final String name;

  Criterion({required this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Criterion && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => '(name: $name)';
}
