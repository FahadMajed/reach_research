
// abstract class BaseResearchNotifier extends StateNotifier<AsyncValue<Research>>
//     implements BaseResearch {


//   Research get research => state.value is SingularResearch
//       ? state.value! as SingularResearch
//       : state.value! as GroupResearch;
//   GroupResearch get groupResearch => state as GroupResearch;
//   SingularResearch get singularResearch => state as SingularResearch;

//   void set(Research research) => state = AsyncData(research);

//   @protected
//   Future<void> updateData() async =>
//       await repository.updateData(research, research.researchId);

//   @protected
//   Future<void> updateField(String fieldName, dynamic fieldData) async =>
//       await repository.updateField(research.researchId, fieldName, fieldData);

//   @protected
//   void decrementEnrollments({required String participantId}) => updateState(
//         numberOfEnrolled: research.numberOfEnrolled - 1,
//         enrolledIds: [
//           ...research.enrolledIds
//             ..remove(
//               participantId,
//             ),
//         ],
//       );
// }
