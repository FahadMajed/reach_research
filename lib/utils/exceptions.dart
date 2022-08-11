class ResearchException implements Exception {
  final message;

  ResearchException(
    this.message,
  );

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
