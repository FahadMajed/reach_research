import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

//ACTIONS MUST PERSISTS
abstract class BaseResearch {
  Future<void> getResearch();

  Future<void> getEnrolledResearch();

  Future<void> addResearch(Research research);

  Future<void> addParticipant(Participant participant);

  Future<void> startResearch(
    List<Phase> phases, {
    List enrollmentsResearcherChattedIds,
  });

  Future<void> togglePhase(int index);

  Future<void> getMeetings();
  Future<void> addMeeting(Meeting meeting);
  Future<void> removeMeeting(Meeting meeting);
  Future<void> updateMeeting(int index, Meeting meeting);

  // Future<void> removeParticipants(List toRemoveIds);
  Future<void> kickParticipant(String participantId);

  Future<void> requestParticipants(int number);
  Future<void> stopRequest();
  Future<void> updateParticipantsRequest(int newNumber);

  Future<void> endResearch();

  Future<void> removeResearch();
}
