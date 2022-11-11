import 'package:reach_research/research/domain/domain.dart';
import 'package:reach_research/research/research.dart';

class ScheduleMapper {
  static Schedule fromMap(Map<String, dynamic> data) {
    return Schedule(
      meetingsTimeSlots: List.from(data['meetingsTimeSlots']),
      meetingsDays: List.from(data['meetingsDays']),
      meetingsMethods: List.from(data['meetingsMethods']),
      numberOfMeetings: data['numberOfMeetings']?.toInt() ?? 0,
      startDate: data['startDate'] ?? '',
    );
  }

  static Map<String, dynamic> toMap(Schedule schedule) {
    return {
      'meetingsTimeSlots': schedule.meetingsTimeSlots,
      'meetingsDays': schedule.meetingsDays,
      'meetingsMethods': schedule.meetingsMethods,
      'numberOfMeetings': schedule.numberOfMeetings,
      'startDate': schedule.startDate,
    };
  }
}
