import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchsRepository extends BaseRepository<Research, Meeting> {
  ResearchsRepository({required super.remoteDatabase});

  Future<Meeting> addMeeting(String reserachId, Meeting meeting) async {
    final docId = await createSubdocumentNoId(
      reserachId,
      meeting,
    );

    await remoteDatabase.updateField(docId, 'id', docId);

    return meeting.copyWith(id: docId);
  }

  Future<void> updateMeeting(String researchId, Meeting meeting) async =>
      await remoteDatabase.updateSubdoc(
        researchId,
        meeting.id!,
        meeting.toMap(),
      );

  Future<void> removeMeeting(String researchId, Meeting meeting) async =>
      await remoteDatabase.deleteSubdoc(
        researchId,
        meeting.id!,
      );

  Future<void> updateResearcher(
          String researchId, Researcher researcher) async =>
      await updateField(researchId, 'researcher', researcher.toMap());

  Future<Research> getResearch(String researcherId) async => await getQuery(
        remoteDatabase
            .where(
          'researcher.researchId',
          isEqualTo: researcherId,
        )
            .where(
          'researchState',
          whereIn: [
            ResearchState.ongoing.index,
            ResearchState.upcoming.index,
          ],
        ),
      ).then((researchs) =>
          researchs.isNotEmpty ? researchs.first : Research.empty());
}

final researchsRepoPvdr = Provider(
  (ref) => ResearchsRepository(
    remoteDatabase: RemoteDatabase(
      db: ref.read(databasePvdr),
      collectionPath: 'researchs',
      fromMap: (snapshot, _) => researchFromMap(snapshot.data()!),
      toMap: (research, _) => researchToMap(research),
      subCollectionPath: 'meetings',
      subFromMap: (snapshot, _) => snapshot.data() != null
          ? Meeting.fromFirestore(snapshot.data()!)
          : Meeting.empty(),
      subToMap: (m, _) => m.toMap(),
    ),
  ),
);


//  Future<List<Research>> getResearchs(
//     bool isResearcher, {
//     String? researcherId,
//   }) async {
//     if (isResearcher) {
//       final query = remoteDatabase
//           .where('researcher.researcherId', isEqualTo: researcherId)
//           .where('researchState', whereIn: [
//         ResearchState.upcoming.index,
//         ResearchState.ongoing.index,
//       ]);
//       return await getQuery(query);
//     }

//     final List<Research> allUpcomingResearchs = await getQuery(
//       remoteDatabase.where(
//         'researcher.researcherId',
//         isEqualTo: ResearchState.upcoming.index,
//       ),
//     );

//     final List<Research> requestingParticipantsResearchs = await getQuery(
//       remoteDatabase.where(
//         'isRequestingParticipants',
//         isEqualTo: true,
//       ),
//     );

//     return allUpcomingResearchs..addAll(requestingParticipantsResearchs);
//   }

//   Future<List<Research>> getEnrolledToResearchs(String participantId) async =>
//       await getQuery(
//         remoteDatabase.where(
//           'state',
//           whereIn: [
//             ResearchState.ongoing.index,
//             ResearchState.upcoming.index,
//             ResearchState.redeeming.index,
//           ],
//         ).where(
//           'enrolledIds',
//           arrayContains: participantId,
//         ),
//       );