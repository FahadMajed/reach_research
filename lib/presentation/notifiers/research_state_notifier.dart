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
    state = state.copyWith(
      researcher: researcher,
      researchId: researchId,
    );
  }

  void setTitleAndDesc({
    required String title,
    required String desc,
  }) {
    state = state.copyWith(
      title: title,
      desc: desc,
    );
  }

  void setCategory(String category) => state = state.copyWith(
        category: category,
        image: setCategoryImage(category),
      );

  String setCategoryImage(String category) => '$category${4.toString()}.webp';

  List<String> getCategoryPhotos() =>
      [for (int i = 1; i < 7; i++) "${state.category}$i.webp"];

  void addCriterion(String criterionName) => state = state.copyWith(
        criteria: {
          ...state.criteria,
          criterionName: criteriaDefaultRanges[criterionName]!
        },
      );

  void updateCriterion(Criterion criterion) => state =
      state.copyWith(criteria: {...state.criteria, criterion.name: criterion});

  void removeCriterion(String criterionName) =>
      state = state.copyWith(criteria: {
        ...state.criteria
          ..removeWhere((key, value) => value.name == criterionName),
      });

  void updateCustomizedQuestion(int index, Question question) =>
      state = state.copyWith(
          questions: state.questions
            ..removeAt(index)
            ..insert(index, question));

  void addCustomizedQuestion(Question question) => state = state.copyWith(
        questions: [...state.questions, question],
      );

  void removeQuestionAt(int index) => state = state.copyWith(
        questions: state.questions..removeAt(index),
      );

  void removeLastQuestion() => state = state.copyWith(
      questions:
          state.questions.where((q) => q != state.questions.last).toList());

  void setNumberOfMeetings(int meetingsCounter) =>
      state = state.copyWith(numberOfMeetings: meetingsCounter);

  void addPreferredDay(String day) {
    if (state.preferredDays.contains(day)) {
      removePreferredDay(day);
    } else {
      state = state.copyWith(
        preferredDays: [
          for (final d in days)
            if ((state.preferredDays.contains(d) || d == day)) d
        ],
      );
    }
  }

  void removePreferredDay(String day) => state = state.copyWith(
        preferredDays: [
          ...state.preferredDays..remove(day),
        ],
      );

  void addPreferredTime(String time) {
    if (state.preferredTimes.contains(time)) {
      removePreferredTime(time);
    } else {
      state = state.copyWith(
        preferredTimes: [
          for (final t in times)
            if ((state.preferredTimes.contains(t) || t == time)) t
        ],
      );
    }
  }

  void removePreferredTime(String time) => state = state.copyWith(
        preferredTimes: [
          ...state.preferredTimes..remove(time),
        ],
      );
  void addPreferredMethod(String method) {
    if (state.preferredMethods.contains(method)) {
      removePreferredMethod(method);
    } else {
      state = state.copyWith(
        preferredMethods: [
          ...state.preferredMethods,
          method,
        ],
      );
    }
  }

  void removePreferredMethod(String method) => state = state.copyWith(
        preferredMethods: [...state.preferredMethods..remove(method)],
      );

  bool scheduleIsNotEmpty() =>
      state.preferredDays.isNotEmpty &&
      state.preferredTimes.isNotEmpty &&
      state.preferredMethods.isNotEmpty &&
      state.startDate != DateTime.now().toString().substring(0, 10);

  void setStartDate(String date) => state = state.copyWith(startDate: date);

  void addBenefit(Benefit benefit) =>
      state = state.copyWith(benefits: [...state.benefits, benefit]);

  void removeBenefit(String name) => state = state.copyWith(
      benefits: state.benefits.where((b) => b.benefitName != name).toList());

  void setImage(String image) => state = state.copyWith(image: image);

  void setSampleSize(int sampleSize) =>
      state = state.copyWith(sampleSize: sampleSize);

  void setResearchType({required bool isGroupResearch}) =>
      state = state.copyWith(isGroupResearch: isGroupResearch);

  void updateBenefitPlace(String benefitName, String place) {
    final benefits = state.benefits;
    state = state.copyWith(
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
    state = state.copyWith(
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
