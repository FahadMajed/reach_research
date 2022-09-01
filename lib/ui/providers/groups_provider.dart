import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

final groupsPvdr =
    StateNotifierProvider<GroupsNotifier, AsyncValue<List<Group>>>(
  (ref) {
    final groupsRepo = ref.read(groupsRepoPvdr);
    final research = ref.watch(researchPvdr).value ?? Research.empty();
    final chatsRepo = ref.read(chatsRepoPvdr);
    final partsRepo = ref.read(partsRepoPvdr);
    return GroupsNotifier(
      research: research as GroupResearch,
      getGroupsForResearch: GetGroupsForResearch(groupsRepo),
      addEmptyGroup: AddEmptyGroup(groupsRepo),
      addUniqueBenefit: AddUniqueGroupBenefit(groupsRepo),
      addUnifiedBenefit: AddUnifiedGroupBeneftit(groupsRepo),
      addParticipantToGroup: AddParticipantToGroup(
        groupsRepository: groupsRepo,
        chatsRepository: chatsRepo,
      ),
      changeParticipantGroup: ChangeParticipantGroup(groupsRepo),
      removeGroup: RemoveGroup(
        groupsRepository: groupsRepo,
        chatsRepository: chatsRepo,
        participantsRepository: partsRepo,
      ),
      kickParticipant: KickParticipantFromGroup(
        groupsRepository: groupsRepo,
        chatsRepository: chatsRepo,
        participantsRepository: partsRepo,
      ),
    );
  },
);
