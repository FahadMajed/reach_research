import 'package:reach_auth/providers/providers.dart';
import 'package:reach_chats/repositories/chats_repository.dart';
import 'package:reach_core/core/core.dart';
import 'package:reach_core/core/data/repositories/notifications_repository.dart';
import 'package:reach_research/domain/use_cases/research/get_enrolled_research.dart';
import 'package:reach_research/research.dart';

final researchPvdr =
    StateNotifierProvider<ResearchNotifier, AsyncValue<Research>>(
  (ref) {
    final repo = ref.read(researchsRepoPvdr);
    final chatsRepo = ref.read(chatsRepoPvdr);
    final notificationsRepo = ref.read(notificationsRepoPvdr);
    final researchersRepo = ref.read(researcherRepoPvdr);
    final partsRepo = ref.read(partsRepoPvdr);

    final uid = ref.watch(userIdPvdr);
    final isResearcher = ref.read(isResearcherPvdr);

    return ResearchNotifier(
      uid: uid,
      isResearcher: isResearcher,
      addMeeting: AddMeeting(repo),
      getEnrolledResearch: GetEnrolledResearch(repo),
      addParticipantToResearch: AddParticipantToResearch(
        repo,
        partsRepo,
        notificationsRepo,
      ),
      addResearch: AddResearch(repo, researchersRepo),
      endResearch: EndResearch(
        researcherRepository: researchersRepo,
        researchsRepository: repo,
      ),
      kickParticipant: KickParticipant(
        repo,
      ),
      removeMeeting: RemoveMeeting(repo),
      requestParticipants: RequestParticipants(repo),
      startResearch: StartResearch(
        chatsRepository: chatsRepo,
        researchsRepository: repo,
      ),
      stopRequest: StopRequest(repo),
      togglePhase: TogglePhase(repo),
      updateMeeting: UpdateMeeting(repo),
      updateParticipantsRequest: UpdateParticipantsRequest(repo),
      getResearch: GetResearch(repo),
      removeParticipants: RemoveParticipants(repo),
    );
  },
);

//TODO GO TO RESEARCHER
final researchStatePvdr =
    StateNotifierProvider<ResearchStateNotifier, Research>(
  (ref) {
    final researcher = ref.watch(researcherPvdr).value!;
    return ResearchStateNotifier(
      researcher,
      Formatter.formatResearchId(
        researcher.researcherId,
      ),
    );
  },
);

final isResearcherPvdr = Provider((ref) => true);
