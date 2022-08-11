import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final researchsRepoPvdr = Provider(
  (ref) => ResearchsRepository(ref.read(databaseProvider)),
);

class ResearchsRepository implements DatabaseRepository<Research> {
  final FirebaseFirestore _database;
  late CollectionReference<Research> collection;

  ResearchsRepository(
    this._database,
  ) {
    collection = _database.collection("researchs").withConverter<Research>(
          fromFirestore: (snapshot, _) => researchFromMap(snapshot.data()!),
          toFirestore: (research, _) => researchToMap(research),
        );
  }

  Future<List<Research>> getEnrolledToResearchs(String participantId) async =>
      collection
          .where("enrolledIds", arrayContains: participantId)
          .where("state", whereIn: [
            ResearchState.Ongoing.index,
            ResearchState.Upcoming.index,
            ResearchState.Redeeming.index,
          ])
          .get()
          .then((query) => query.docs.map((doc) => doc.data()).toList());

  Stream<Research> streamResearch(String researchId) => collection
      .doc(researchId)
      .snapshots()
      .map((researchDoc) => researchDoc.data()!);

  @override
  Future<Research> getDocument(String id) =>
      collection.doc(id).get().then((researchDoc) => researchDoc.data()!);

  @override
  Future<List<Research>> getDocuments(
    String id, {
    bool defaultFlow = true,
  }) async {
    if (defaultFlow) {
      return collection
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

    List<Research> allUpcomingResearchs = await collection
        .where(
          "state",
          isEqualTo: ResearchState.Upcoming.index,
        )
        .limit(50)
        .get()
        .then((query) => query.docs.map((doc) => doc.data()).toList());

    List<Research> requestingParticipantsResearchs = await collection
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
  Future<void> deleteDocument(id) async => await collection.doc(id).delete();

  @override
  Future<Research> createDocument(Research research) async {
    final researchDoc = await collection.add(research);
    research = copyResearchWith(research, researchId: researchDoc.id);

    await updateDocument(research);
    return research;
  }

  @override
  Future<void> updateDocument(Research research) =>
      collection.doc(research.researchId).update(researchToMap(research));

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
      await collection
          .doc(docId)
          .update({field: (data as Researcher).toPartialMap()});
}
