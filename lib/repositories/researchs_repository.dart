import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final researchsRepoPvdr = Provider(
  (ref) => ResearchsRepository(ref.read(databaseProvider)),
);

class ResearchsRepository implements DatabaseRepository<Research> {
  late final FirebaseFirestore _database;

  late final CollectionReference<Research> _collection;

  ResearchsRepository(this._database) {
    _collection = _database.collection("researchs").withConverter<Research>(
          fromFirestore: (snapshot, _) => researchFromMap(snapshot.data()!),
          toFirestore: (research, _) => researchToMap(research),
        );
  }

  Future<List<Research>> getEnrolledToResearchs(String participantId) async =>
      _collection
          .where("enrolledIds", arrayContains: participantId)
          .where("state", whereIn: [
            ResearchState.Ongoing.index,
            ResearchState.Upcoming.index,
            ResearchState.Redeeming.index,
          ])
          .get()
          .then((query) => query.docs.map((doc) => doc.data()).toList());

  Stream<Research> streamResearch(String researchId) => _collection
      .doc(researchId)
      .snapshots()
      .map((researchDoc) => researchDoc.data()!);

  @override
  Future<Research> getDocument(String id) =>
      _collection.doc(id).get().then((researchDoc) => researchDoc.data()!);

  @override
  Future<List<Research>> getDocuments(
    String id, {
    bool defaultFlow = true,
  }) async {
    if (defaultFlow) {
      return _collection
          .where('researcher.researcherId', isEqualTo: id)
          .where('state', whereIn: [
            ResearchState.Ongoing.index,
            ResearchState.Upcoming.index,
            ResearchState.Redeeming.index
          ])
          .get()
          .then((value) =>
              value.docs.map((researchDoc) => researchDoc.data()).toList());
    }

    List<Research> allUpcomingResearchs = await _collection
        .where(
          "state",
          isEqualTo: ResearchState.Upcoming.index,
        )
        .limit(50)
        .get()
        .then((query) => query.docs.map((doc) => doc.data()).toList());

    List<Research> requestingParticipantsResearchs = await _collection
        .where(
          "isRequestingParticipants",
          isEqualTo: true,
        )
        .limit(50)
        .get()
        .then((query) => query.docs.map((doc) => doc.data()).toList());

    return allUpcomingResearchs..addAll(requestingParticipantsResearchs);
  }

  @override
  Future<void> deleteDocument(id) async => await _collection.doc(id).delete();

  @override
  Future<Research> createDocument(Research research) async {
    await _collection.doc(research.researchId).set(research);

    return research;
  }

  @override
  Future<void> updateDocument(Research research) =>
      _collection.doc(research.researchId).update(researchToMap(research));

  @override
  Future<void> updateFieldArrayRemove(String id, String field, List remove) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateFieldArrayUnion(String id, String field, List union) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateField(String docId, String field, data) async =>
      await _collection
          .doc(docId)
          .update({field: (data as Researcher).toPartialMap()});
}
