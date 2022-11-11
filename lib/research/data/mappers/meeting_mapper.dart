import 'package:reach_core/lib.dart';
import 'package:reach_research/research.dart';

class MeetingsMapper {
  static Meeting fromMap(data) {
    return Meeting(
      id: data['id'] ?? '',
      researchId: data['researchId'],
      title: data['title'] ?? " - ",
      starts: Formatter.formatDateTime((data['starts'] as Timestamp).toDate()),
      ends: data['ends'] ?? DateTime.now(),
      link: data["link"] ?? "",
      inviteesIds: data["inviteesIds"] ?? [],
      isOnline: data['isOnline'] ?? false,
      inviteesNames: data["inviteesNames"] ?? [],
    );
  }

  static Map<String, dynamic> toMap(Meeting meeting) {
    return {
      'id': meeting.id,
      'researchId': meeting.researchId,
      'title': meeting.title,
      'starts': Timestamp.fromDate(DateTime.parse(meeting.starts)),
      'link': meeting.link,
      'ends': meeting.ends,
      'isOnline': meeting.isOnline,
      "inviteesIds": meeting.inviteesIds,
      "inviteesNames": meeting.inviteesNames
    };
  }

  static List<Meeting> fromMapList(Map<String, dynamic> data) => (data['meetings'] as List).map(fromMap).toList();

  static List<Map<String, dynamic>> toMapList(List<Meeting> elements) => elements.map(toMap).toList();
}
