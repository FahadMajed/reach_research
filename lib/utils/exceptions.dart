class ResearchException implements Exception {
  final String message;

  ResearchException(
    this.message,
  );

  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResearchException && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class ResearchIsFull extends ResearchException {
  ResearchIsFull() : super("Research Is Full");
}

class ResearchRequestIsFull extends ResearchException {
  ResearchRequestIsFull() : super("Research Is Full");
}

class CannotDeleteAllGroups extends ResearchException {
  CannotDeleteAllGroups() : super("cannot delete all groups");
}

class ResearchNotFound extends ResearchException {
  ResearchNotFound() : super("research not found");
}
