import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/data/repositories/notifications_repository.dart';
import 'package:reach_research/domain/use_cases/research/remove_participants.dart';
import 'package:reach_research/research.dart';

final researchPvdr =
    StateNotifierProvider<ResearchNotifier, AsyncValue<Research>>(
  (ref) {
    final repo = ref.read(researchsRepoPvdr);
    final chatsRepo = ref.read(chatsRepoPvdr);
    final notificationsRepo = ref.read(notificationsRepoPvdr);
    final researchersRepo = ref.read(researcherRepoPvdr);

    final researcherId =
        ref.watch(researcherPvdr.select((r) => r.value?.researcherId ?? ""));

    return ResearchNotifier(
      researcherId: researcherId,
      addMeetingUseCase: AddMeeting(repo),
      addParticipantToResearch: AddParticipantToResearch(
        repo,
        notificationsRepo,
      ),
      addResearchUseCase: AddResearch(repo, researchersRepo),
      endResearchUseCase: EndResearch(
        researcherRepository: researchersRepo,
        researchsRepository: repo,
      ),
      kickParticipantUseCase: KickParticipant(
        repo,
      ),
      removeMeetingUseCase: RemoveMeeting(repo),
      requestParticipantsUseCase: RequestParticipants(repo),
      startResearchUseCase: StartResearch(
        chatsRepository: chatsRepo,
        researchsRepository: repo,
      ),
      stopRequestUseCase: StopRequest(repo),
      togglePhaseUseCase: TogglePhase(repo),
      updateMeetingUseCase: UpdateMeeting(repo),
      updateParticipantsRequestUseCase: UpdateParticipantsRequest(repo),
      getResearchUseCase: GetResearch(repo),
      removeParticipantsUseCase: RemoveParticipants(repo),
    );
  },
);

//TODO GO TO RESEARCHER
final researchStatePvdr =
    StateNotifierProvider<ResearchStateNotifier, Research>(
  (ref) {
    final researcher = ref.watch(researcherPvdr).value;
    return ResearchStateNotifier(
      researcher ?? Researcher.empty(),
      Formatter.formatResearchId(
        researcher?.researcherId ?? "",
      ),
    );
  },
);
