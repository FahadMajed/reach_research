import 'package:reach_core/core/core.dart';

class Schedule extends Equatable {
  final List meetingsTimeSlots;
  final List meetingsDays;
  final List meetingsMethods;
  final int numberOfMeetings;
  final String startDate;
  const Schedule({
    required this.meetingsTimeSlots,
    required this.meetingsDays,
    required this.meetingsMethods,
    required this.numberOfMeetings,
    required this.startDate,
  });

  Schedule copyWith({
    List? meetingsTimeSlots,
    List? meetingsDays,
    List? meetingsMethods,
    int? numberOfMeetings,
    String? startDate,
  }) {
    return Schedule(
      meetingsTimeSlots: meetingsTimeSlots ?? this.meetingsTimeSlots,
      meetingsDays: meetingsDays ?? this.meetingsDays,
      meetingsMethods: meetingsMethods ?? this.meetingsMethods,
      numberOfMeetings: numberOfMeetings ?? this.numberOfMeetings,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  List<Object?> get props => [
        meetingsTimeSlots,
        meetingsDays,
        meetingsMethods,
        numberOfMeetings,
        startDate,
      ];
}
