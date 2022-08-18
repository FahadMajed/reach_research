class ResearchException implements Exception {
  final String message;

  ResearchException(
    this.message,
  );

  @override
  String toString() {
    return message;
  }
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
