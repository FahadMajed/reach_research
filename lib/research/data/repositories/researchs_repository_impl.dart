import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

class ResearchsRepositoryImpl implements ResearchsRepository {
  ResearchsRepositoryImpl({
    required RemoteDatabase<Research, Meeting> remoteDatabase,
  }) {
    _db = remoteDatabase;
  }

  late final RemoteDatabase<Research, Meeting> _db;

  @override
  Future<void> addResearch(Research research) async {
    await _db.createDocument(research, research.researchId);
  }

  @override
  Future<Research> getResearchForResearcher(String researcherId) async => await _db
      .getQuery(DatabaseQuery(
        [
          Where('researcher.researcherId', isEqualTo: researcherId),
          Where('researchState', whereIn: [ResearchState.ongoing.index, ResearchState.upcoming.index])
        ],
      ))
      .then((researchs) => researchs.isEmpty ? throw ResearchNotFound() : researchs.first);

  @override
  Future<void> removeResearch(String researchId) async {
    await _db.deleteDocument(researchId);
  }

  @override
  Future<void> updateResearch(Research research) async {
    await _db.updateDocument(research, research.researchId);
  }

  @override
  Future<void> addMeeting(Meeting meeting) async => await _db.createSubdocument(
        parentId: meeting.researchId,
        subDocId: meeting.id!,
        data: meeting,
      );

  @override
  Future<void> updateMeeting(Meeting meeting) async => await _db.updateSubdoc(
        meeting.researchId,
        meeting.id!,
        MeetingsMapper.toMap(meeting),
      );

  @override
  Future<void> removeMeeting(Meeting meeting) async => await _db.deleteSubdoc(
        meeting.researchId,
        meeting.id!,
      );

  @override
  Future<List<Meeting>> getMeetings(String researchId) async => await _db.getAllSubcollection(researchId);

  @override
  Future<void> updateResearcher(String researchId, Researcher researcher) async =>
      await _db.updateField(researchId, 'researcher', ResearcherMapper.toMap(researcher));

  @override
  Future<List<Research>> getResearchsForParticipant(String participantId) async {
    final upcomings = await _db.getQuery(DatabaseQuery([
      Where('researchState', isEqualTo: ResearchState.upcoming.index),
      // Where('enrolledIds', whereNotIn: [participantId]),
      // Where('rejectedIds', whereNotIn: [participantId])
    ]));

    final requestings = await _db.getQuery(DatabaseQuery([
      Where('participantsRequest.isActive', isEqualTo: true),
      // Where('enrolledIds', whereNotIn: [participantId]),
      // Where('rejectedIds', whereNotIn: [participantId])
    ]));

    return [...upcomings, ...requestings];
  }

  @override
  Future<Research?> getEnrolledResearch(String participantId) async => await _db
      .getQuery(
        DatabaseQuery(
          [
            Where(
              'enrolledIds',
              arrayContains: participantId,
            ),
          ],
        ),
      )
      .then((researchs) => researchs.isNotEmpty ? researchs.first : null);

  @override
  Future<void> removeParticipants(String researchId, List removedIds) async {
    await _db.updateDocumentRaw(
      {
        'numberOfEnrolled': _db.increment(-removedIds.length),
        'enrolledIds': _db.arrayRemove(removedIds),
      },
      researchId,
    );
  }

  @override
  Future<void> kickParticipant(String researchId, String partId) async {
    await _db.updateDocumentRaw(
      {
        'numberOfEnrolled': _db.increment(-1),
        'enrolledIds': _db.arrayRemove([partId]),
      },
      researchId,
    );
  }

  @override
  Future<void> updatePhases(List<Phase> phases, String researchId) async => _db.updateField(
        researchId,
        'phases',
        PhasesMapper.toMapList(phases),
      );

  @override
  Future<void> updateResearchState(String researchId, ResearchState state) async => _db.updateField(
        researchId,
        'researchState',
        state.index,
      );

  @override
  Future<void> addParticipantToRejected(
    String participantId,
    String researchId,
  ) async =>
      await _db.updateFieldArrayUnion(
        researchId,
        'rejectedIds',
        [participantId],
      );

  @override
  Future<Meeting?> getUpcomingParticipantMeeting(
    String participantId,
    String researchId,
  ) async =>
      await _db
          .getQuerySubcollection(
            researchId,
            DatabaseQuery(
              [
                Where(
                  'inviteesIds',
                  arrayContains: participantId,
                ),
                Where(
                  'starts',
                  isGreaterThanOrEqualTo: Timestamp.now(),
                )
              ],
              orderBy: "starts",
              limit: 1,
            ),
          )
          .then(
            (query) => query.isNotEmpty ? query.first : null,
          );
}

final researchsRepoPvdr = Provider<ResearchsRepository>(
  (ref) => ResearchsRepositoryImpl(
    remoteDatabase: FirestoreRemoteDatabase<Research, Meeting>(
      db: ref.read(databasePvdr),
      collectionPath: 'researchs',
      fromMap: (snapshot, _) => researchFromMap(snapshot.data()!),
      toMap: (research, _) => researchToMap(research),
      subCollectionPath: 'meetings',
      subFromMap: (snapshot, _) => snapshot.data() != null ? MeetingsMapper.fromMap(snapshot.data()!) : Meeting.empty(),
      subToMap: (m, _) => MeetingsMapper.toMap(m),
    ),
  ),
);
