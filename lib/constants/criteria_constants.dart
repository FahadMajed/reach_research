import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reach_core/core/theme/theme.dart';
import 'package:reach_research/research.dart';

const List<String> kGender = ['Choose Gender', "Female", "Male"];

const List<String> kNationality = [
  'Choose Nation',
  'Saudi Arabia',
  'Kuwait',
  'United Arab Emirates'
];

final Map<String, Criterion> criteriaEmptyStateRanges = {
  "age": RangeCriterion(
    from: 18,
    to: 85,
    name: "age",
  ),
  "height": RangeCriterion(
    from: 110,
    to: 200,
    name: "height",
  ),
  "weight": RangeCriterion(
    from: 40,
    to: 200,
    name: "weight",
  ),
  "income": RangeCriterion(
    from: 0,
    to: 40000,
    name: "income",
  ),
  "gender": ValueCriterion(
    condition: "",
    name: "gender",
  ),
  "nation": ValueCriterion(
    condition: "",
    name: "nation",
  ),
};

final Map<String, Criterion> criteriaDefaultRanges = {
  "age": RangeCriterion(
    from: 21,
    to: 42,
    name: "age",
  ),
  "height": RangeCriterion(
    from: 110,
    to: 140,
    name: "height",
  ),
  "weight": RangeCriterion(
    from: 40,
    to: 80,
    name: "weight",
  ),
  "income": RangeCriterion(
    from: 0,
    to: 15000,
    name: "income",
  ),
  "gender": ValueCriterion(
    condition: "",
    name: "gender",
  ),
  "nation": ValueCriterion(
    condition: "",
    name: "nation",
  )
};

final List<String> criteriaMenue = [
  "age",
  "height",
  "weight",
  "income",
  "gender",
  "nation"
];

const Map<String, Icon> criteriaIconsMenue = {
  "age": Icon(
    FontAwesomeIcons.calendar,
    size: 16,
    color: accentColor,
  ),
  "height": Icon(
    Icons.height,
    size: 20,
    color: accentColor,
  ),
  "weight": Icon(
    FontAwesomeIcons.weight,
    size: 16,
    color: accentColor,
  ),
  "income": Icon(
    FontAwesomeIcons.chartLine,
    size: 16,
    color: accentColor,
  ),
  "gender": Icon(
    FontAwesomeIcons.venusMars,
    size: 16,
    color: accentColor,
  ),
  "nation": Icon(
    FontAwesomeIcons.idCard,
    size: 16,
    color: accentColor,
  )
};
const RangeValues ageValues = RangeValues(18.0, 85.0);
const RangeValues heightValues = RangeValues(110.0, 210.0);
const RangeValues weightValues = RangeValues(40.0, 200.0);
const RangeValues incomeValues = RangeValues(0.0, 40000.0);

const Map<String, RangeValues> criterionMinMaxRanges = {
  "age": ageValues,
  "height": heightValues,
  "weight": weightValues,
  "income": incomeValues,
};

const Map<String, List<String>> criterionPickerList = {
  "gender": kGender,
  "nation": kNationality
};
