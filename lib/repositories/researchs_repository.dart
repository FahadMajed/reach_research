import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchsRepository extends BaseRepository<Research, void> {
  ResearchsRepository({required super.remoteDatabase});

  Future<List<Research>> getResearchs(
    bool isResearcher, {
    String? researcherId,
  }) async {
    if (isResearcher) {
      final query = remoteDatabase
          .where('researcher.researcherId', isEqualTo: researcherId)
          .where('researchState', whereIn: [
        ResearchState.upcoming.index,
        ResearchState.ongoing.index,
      ]);
      return await getQuery(query);
    }

    final List<Research> allUpcomingResearchs = await getQuery(
      remoteDatabase.where(
        'researcher.researcherId',
        isEqualTo: ResearchState.upcoming.index,
      ),
    );

    final List<Research> requestingParticipantsResearchs = await getQuery(
      remoteDatabase.where(
        'isRequestingParticipants',
        isEqualTo: true,
      ),
    );

    return allUpcomingResearchs..addAll(requestingParticipantsResearchs);
  }

  Future<List<Research>> getEnrolledToResearchs(String participantId) async =>
      await getQuery(
        remoteDatabase.where(
          'state',
          whereIn: [
            ResearchState.ongoing.index,
            ResearchState.upcoming.index,
            ResearchState.redeeming.index,
          ],
        ).where(
          'enrolledIds',
          arrayContains: participantId,
        ),
      );

  Future<void> updateResearcher(
          String researchId, Researcher researcher) async =>
      await updateField(researchId, 'researcher', researcher.toMap());
}

final researchsRepoPvdr = Provider(
  (ref) => ResearchsRepository(
    remoteDatabase: RemoteDatabase(
      db: ref.read(databaseProvider),
      collectionPath: 'researchs',
      fromMap: (snapshot, _) => researchFromMap(snapshot.data()!),
      toMap: (research, _) => researchToMap(research),
    ),
  ),
);
