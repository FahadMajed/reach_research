import 'package:reach_core/core/core.dart';
import 'package:reach_research/research.dart';

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

  Research get research => state;

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
      [for (int i = 1; i < 7; i++) "${research.category}$i.webp"];

  void addCriterion(String criterionName) => _updateState(
        criteria: {
          ...research.criteria,
          criterionName: criteriaDefaultRanges[criterionName]!
        },
      );

  void updateCriterion(Criterion criterion) =>
      _updateState(criteria: {...research.criteria, criterion.name: criterion});

  void removeCriterion(String criterionName) => _updateState(criteria: {
        ...research.criteria
          ..removeWhere((key, value) => value.name == criterionName),
      });

  void updateCustomizedQuestion(int index, Question question) => _updateState(
      questions: research.questions
        ..removeAt(index)
        ..insert(index, question));

  void addCustomizedQuestion(Question question) => _updateState(
        questions: [...research.questions, question],
      );

  void removeQuestionAt(int index) => _updateState(
        questions: research.questions..removeAt(index),
      );

  void removeLastQuestion() => _updateState(
      questions: research.questions
          .where((q) => q != research.questions.last)
          .toList());

  void setNumberOfMeetings(int meetingsCounter) =>
      _updateState(numberOfMeetings: meetingsCounter);

  void addMeetingDay(String day) {
    if (research.meetingsDays.contains(day)) {
      removeMeetingDay(day);
    } else {
      _updateState(
        meetingsDays: [
          for (final d in days)
            if ((research.meetingsDays.contains(d) || d == day)) d
        ],
      );
    }
  }

  void removeMeetingDay(String day) => _updateState(
        meetingsDays: [
          ...research.meetingsDays..remove(day),
        ],
      );

  void addMeetingTimeSlot(String time) {
    if (research.meetingsTimeSlots.contains(time)) {
      removeMeetingTimeSlot(time);
    } else {
      _updateState(
        meetingsTimeSlots: [
          for (final t in times)
            if ((research.meetingsTimeSlots.contains(t) || t == time)) t
        ],
      );
    }
  }

  void removeMeetingTimeSlot(String time) => _updateState(
        meetingsTimeSlots: [
          ...research.meetingsTimeSlots..remove(time),
        ],
      );
  void addMeetingMethod(String method) {
    if (research.meetingsMethods.contains(method)) {
      removeMeetingMethod(method);
    } else {
      _updateState(
        meetingsMethods: [
          ...research.meetingsMethods,
          method,
        ],
      );
    }
  }

  void removeMeetingMethod(String method) => _updateState(
        meetingsMethods: [...research.meetingsMethods..remove(method)],
      );

  bool scheduleIsNotEmpty() =>
      research.meetingsDays.isNotEmpty &&
      research.meetingsTimeSlots.isNotEmpty &&
      research.meetingsMethods.isNotEmpty &&
      research.startDate != DateTime.now().toString().substring(0, 10);

  void setStartDate(String date) => _updateState(startDate: date);

  void addBenefit(Benefit benefit) =>
      _updateState(benefits: [...research.benefits, benefit]);

  void removeBenefit(String name) => _updateState(
      benefits: research.benefits.where((b) => b.benefitName != name).toList());

  void setImage(String image) => _updateState(image: image);

  void setSampleSize(int sampleSize) => _updateState(sampleSize: sampleSize);

  void setResearchType({required bool isGroupResearch}) =>
      _updateState(isGroupResearch: isGroupResearch);

  void updateBenefitPlace(String benefitName, String place) {
    final benefits = research.benefits;
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
    final benefits = research.benefits;
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
