import 'package:reach_core/lib.dart';

class ParticipantsRequest extends Equatable {
  final int numberOfRequested;
  final int requestJoiners;

  const ParticipantsRequest({
    required this.numberOfRequested,
    required this.requestJoiners,
  });

  bool get isFullfilled => requestJoiners == numberOfRequested;
  bool get isActive => requestJoiners != numberOfRequested;

  double get progress => requestJoiners / numberOfRequested;

  String get progressToString => "$requestJoiners/$numberOfRequested";

  factory ParticipantsRequest.empty() => const ParticipantsRequest(
        numberOfRequested: 0,
        requestJoiners: 0,
      );

  ParticipantsRequest incrementJoiners() {
    return copyWith(requestJoiners: requestJoiners + 1);
  }

  ParticipantsRequest stop() {
    return ParticipantsRequest.empty();
  }

  ParticipantsRequest copyWith({
    int? numberOfRequested,
    int? requestJoiners,
  }) {
    return ParticipantsRequest(
      numberOfRequested: numberOfRequested ?? this.numberOfRequested,
      requestJoiners: requestJoiners ?? this.requestJoiners,
    );
  }

  @override
  List<Object?> get props => [numberOfRequested, requestJoiners];
}
