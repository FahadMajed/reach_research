import 'package:reach_core/core/models/participant.dart';
import 'package:reach_research/domain/models/models.dart';

//ACTIONS MUST PERSISTS
abstract class BaseResearch {
  Future<void> getResearch();

  Future<void> addResearch(Research research);

  Future<void> addParticipant(Participant participant);

  Future<void> startResearch(
    List<Phase> phases,
    List participantsResearcherChattedIds,
  );

  Future<void> togglePhase(int index);

  Future<void> addMeeting(Meeting meeting);
  Future<void> removeMeeting(Meeting meeting);
  Future<void> updateMeeting(int index, Meeting meeting);

  Future<void> kickParticipant(String participantId);

  Future<void> requestParticipants(int number);
  Future<void> stopRequest();
  Future<void> updateParticipantsRequest(int newNumber);

  Future<void> endResearch();
}
