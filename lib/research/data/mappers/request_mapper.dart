import 'package:reach_research/research/research.dart';

class PartsRequestMapper {
  static ParticipantsRequest fromMap(Map<String, dynamic> data) {
    return ParticipantsRequest(
      numberOfRequested: data['numberOfRequested']?.toInt() ?? 0,
      requestJoiners: data['requestJoiners']?.toInt() ?? 0,
    );
  }

  static Map<String, dynamic> toMap(ParticipantsRequest request) {
    return {
      'isActive': request.isActive,
      'numberOfRequested': request.numberOfRequested,
      'requestJoiners': request.requestJoiners,
    };
  }
}
