import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchsRepository extends BaseRepository<Research, Meeting> {
  ResearchsRepository({required super.remoteDatabase});

  Future<Meeting> addMeeting(String reserachId, Meeting meeting) async {
    final docId = await createSubdocumentNoId(
      reserachId,
      meeting,
    );

    return await remoteDatabase
        .updateSubdocField(reserachId, docId, 'id', docId)
        .then((_) => meeting.copyWith(id: docId));
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

  Future<List<Meeting>> getMeetings(String researchId) async =>
      await getAllSubcollection(researchId);

  Future<void> updateResearcher(
          String researchId, Researcher researcher) async =>
      await updateField(researchId, 'researcher', researcher.toMap());

  Future<Research> getResearch(String researcherId) async => await getQuery(
        where(
          'researcher.researcherId',
          isEqualTo: researcherId,
        ).where(
          'researchState',
          whereIn: [
            ResearchState.ongoing.index,
            ResearchState.upcoming.index,
          ],
        ),
      ).then((researchs) =>
          researchs.isNotEmpty ? researchs.first : throw ResearchNotFound());

  Future<List<Research>> getResearchsForParticipant() async {
    final upcomings = await getQuery(
      where(
        'researchState',
        isEqualTo: ResearchState.upcoming.index,
      ).limit(50),
    );

    final requestings = await getQuery(
      where(
        'isRequestingParticipants',
        isEqualTo: true,
      ).where(
        'researchState',
        isEqualTo: ResearchState.ongoing.index,
      ),
    );

    return [...upcomings, ...requestings];
  }

  Future<Research?> getEnrolledResearch(String participantId) async =>
      await getQuery(where('enrolledIds', arrayContains: participantId))
          .then((researchs) => researchs.isNotEmpty ? researchs.first : null);

  Future<void> incrementGroupsLength(String researchId) async =>
      await remoteDatabase.incrementField(
        researchId,
        'groupsLength',
      );

  Future<void> removeParticipants(String researchId, List removedIds) async {
    //TODO SEPERATE IT TO RESEARCHS DATASOURCE
    await remoteDatabase.updateDocumentRaw({
      'numberOfEnrolled': FieldValue.increment(-removedIds.length),
      'groupsLength': FieldValue.increment(-1),
      'enrolledIds': FieldValue.arrayRemove(removedIds),
    }, researchId);
  }
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
//     where(
//         'researcher.researcherId',
//         isEqualTo: ResearchState.upcoming.index,
//       ),
//     );

//     final List<Research> requestingParticipantsResearchs = await getQuery(
//     where(
//         'isRequestingParticipants',
//         isEqualTo: true,
//       ),
//     );

//     return allUpcomingResearchs..addAll(requestingParticipantsResearchs);
//   }

//   Future<List<Research>> getEnrolledToResearchs(String participantId) async =>
//       await getQuery(
//     where(
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