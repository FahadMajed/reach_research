class ExceptionWithMessage implements Exception {
  final String message;

  ExceptionWithMessage(
    this.message,
  );

  @override
  String toString() {
    return message;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExceptionWithMessage && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class ResearchIsFull extends ExceptionWithMessage {
  ResearchIsFull() : super("Research Is Full");
}

class ResearchRequestIsFull extends ExceptionWithMessage {
  ResearchRequestIsFull() : super("Research Is Full");
}

class CannotDeleteAllGroups extends ExceptionWithMessage {
  CannotDeleteAllGroups() : super("cannot delete all groups");
}

class ResearchNotFound extends ExceptionWithMessage {
  ResearchNotFound() : super("research not found");
}
