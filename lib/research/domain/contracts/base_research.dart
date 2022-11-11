import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

//ACTIONS MUST PERSISTS
//USE CASES
abstract class ResearchsRepository {
  Future<void> addResearch(Research research);

  Future<void> updateResearch(Research research);

  Future<void> removeResearch(String researchId);

  Future<void> addMeeting(Meeting meeting);

  Future<void> updateMeeting(Meeting meeting);
  Future<void> removeMeeting(Meeting meeting);

  Future<List<Meeting>> getMeetings(String researchId);

  Future<void> updateResearcher(String researchId, Researcher researcher);

  Future<Research> getResearchForResearcher(String researcherId);

  Future<List<Research>> getResearchsForParticipant(String participantId);

  Future<Research?> getEnrolledResearch(String participantId);

  Future<void> removeParticipants(String researchId, List removedIds);

  Future<void> kickParticipant(String researchId, String partId);

  Future<void> updatePhases(List<Phase> phases, String researchId);

  Future<void> updateResearchState(String researchId, ResearchState state);

  Future<void> addParticipantToRejected(String participantId, String researchId);

  Future<Meeting?> getUpcomingParticipantMeeting(String participantId, String researchId);
}
