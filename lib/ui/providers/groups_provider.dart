import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_research/domain/use_cases/add_benefit/unified/add_uinified_benefit_group.dart';
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
      getGroupsForResearchUseCase: GetGroupsForResearch(groupsRepo),
      addEmptyGroupUseCase: AddEmptyGroup(groupsRepo),
      addUniqueBenefitUseCase: AddUniqueGroupBenefit(groupsRepo),
      addUnifiedBenefitUseCase: AddUnifiedGroupBeneftit(groupsRepo),
      addParticipantToGroupUseCase: AddParticipantToGroup(groupsRepo),
      changeParticipantGroupUseCase: ChangeParticipantGroup(groupsRepo),
      removeGroupUseCase: RemoveGroup(
        groupsRepository: groupsRepo,
        chatsRepository: chatsRepo,
        participantsRepository: partsRepo,
      ),
      kickParticipantUseCase: KickParticipantFromGroup(
        groupsRepository: groupsRepo,
        chatsRepository: chatsRepo,
        participantsRepository: partsRepo,
      ),
    );
  },
);
