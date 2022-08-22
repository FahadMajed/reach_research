import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

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

//before creation
class ResearchStateNotifier extends StateNotifier<Research> {
  ResearchStateNotifier(Researcher researcher, String researchId)
      : super(Research.empty()) {
    state = copyResearchWith(
      Research.empty(),
      researcher: researcher,
      researchId: researchId,
    );
  }

  void _updateState({
    String? title,
    String? desc,
    String? category,
    Map<String, Criterion>? criteria,
    List<Question>? questions,
    List<Benefit>? benefits,
    int? sampleSize,
    int? numberOfMeetings,
    List? meetingsTimeSlots,
    List? meetingsDays,
    List? meetingsMethods,
    String? startDate,
    String? city,
    String? image,
    bool? isGroupResearch,
  }) =>
      state = copyResearchWith(state,
          title: title,
          desc: desc,
          category: category,
          criteria: criteria,
          questions: questions,
          benefits: benefits,
          sampleSize: sampleSize,
          numberOfMeetings: numberOfMeetings,
          meetingsTimeSlots: meetingsTimeSlots,
          meetingsDays: meetingsDays,
          meetingsMethods: meetingsMethods,
          startDate: startDate,
          city: city,
          image: image,
          isGroupResearch: isGroupResearch);

  void setTitleAndDesc({
    required String title,
    required String desc,
  }) {
    _updateState(
      title: title,
      desc: desc,
    );
  }

  void setCategory(String category) => _updateState(
        category: category,
        image: setCategoryImage(category),
      );

  String setCategoryImage(String category) => '$category${4.toString()}.webp';

  List<String> getCategoryPhotos() =>
      [for (int i = 1; i < 7; i++) "${state.category}$i.webp"];

  void addCriterion(String criterionName) => _updateState(
        criteria: {
          ...state.criteria,
          criterionName: criteriaDefaultRanges[criterionName]!
        },
      );

  void updateCriterion(Criterion criterion) =>
      _updateState(criteria: {...state.criteria, criterion.name: criterion});

  void removeCriterion(String criterionName) => _updateState(criteria: {
        ...state.criteria
          ..removeWhere((key, value) => value.name == criterionName),
      });

  void updateCustomizedQuestion(int index, Question question) => _updateState(
      questions: state.questions
        ..removeAt(index)
        ..insert(index, question));

  void addCustomizedQuestion(Question question) => _updateState(
        questions: [...state.questions, question],
      );

  void removeQuestionAt(int index) => _updateState(
        questions: state.questions..removeAt(index),
      );

  void removeLastQuestion() => _updateState(
      questions:
          state.questions.where((q) => q != state.questions.last).toList());

  void setNumberOfMeetings(int meetingsCounter) =>
      _updateState(numberOfMeetings: meetingsCounter);

  void addMeetingDay(String day) {
    if (state.meetingsDays.contains(day)) {
      removeMeetingDay(day);
    } else {
      _updateState(
        meetingsDays: [
          for (final d in days)
            if ((state.meetingsDays.contains(d) || d == day)) d
        ],
      );
    }
  }

  void removeMeetingDay(String day) => _updateState(
        meetingsDays: [
          ...state.meetingsDays..remove(day),
        ],
      );

  void addMeetingTimeSlot(String time) {
    if (state.meetingsTimeSlots.contains(time)) {
      removeMeetingTimeSlot(time);
    } else {
      _updateState(
        meetingsTimeSlots: [
          for (final t in times)
            if ((state.meetingsTimeSlots.contains(t) || t == time)) t
        ],
      );
    }
  }

  void removeMeetingTimeSlot(String time) => _updateState(
        meetingsTimeSlots: [
          ...state.meetingsTimeSlots..remove(time),
        ],
      );
  void addMeetingMethod(String method) {
    if (state.meetingsMethods.contains(method)) {
      removeMeetingMethod(method);
    } else {
      _updateState(
        meetingsMethods: [
          ...state.meetingsMethods,
          method,
        ],
      );
    }
  }

  void removeMeetingMethod(String method) => _updateState(
        meetingsMethods: [...state.meetingsMethods..remove(method)],
      );

  bool scheduleIsNotEmpty() =>
      state.meetingsDays.isNotEmpty &&
      state.meetingsTimeSlots.isNotEmpty &&
      state.meetingsMethods.isNotEmpty &&
      state.startDate != DateTime.now().toString().substring(0, 10);

  void setStartDate(String date) => _updateState(startDate: date);

  void addBenefit(Benefit benefit) =>
      _updateState(benefits: [...state.benefits, benefit]);

  void removeBenefit(String name) => _updateState(
      benefits: state.benefits.where((b) => b.benefitName != name).toList());

  void setImage(String image) => _updateState(image: image);

  void setSampleSize(int sampleSize) => _updateState(sampleSize: sampleSize);

  void setResearchType({required bool isGroupResearch}) =>
      _updateState(isGroupResearch: isGroupResearch);

  void updateBenefitPlace(String benefitName, String place) {
    final benefits = state.benefits;
    _updateState(
      benefits: [
        for (final b in benefits)
          if (b.benefitName == benefitName)
            b.copyWith(place: " in " + place)
          else
            b,
      ],
    );
  }

  void updateBenefitValue(String benefitName, String value, String suffix) {
    final benefits = state.benefits;
    _updateState(
      benefits: [
        for (final b in benefits)
          if (b.benefitName == benefitName)
            b.copyWith(value: value + suffix)
          else
            b,
      ],
    );
  }

  void clear() => state = Research.empty();
}
