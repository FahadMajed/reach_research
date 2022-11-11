// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:reach_core/core/core.dart';

class Meeting extends Equatable with NamesParser {
  final String? id;
  final String researchId;
  final String title;
  final String starts;
  final String ends;

  final bool isOnline;
  final String link;
  final List inviteesNames;
  final List inviteesIds;

  const Meeting({
    this.id = "",
    required this.researchId,
    required this.title,
    required this.starts,
    required this.ends,
    required this.isOnline,
    this.inviteesNames = const [],
    this.inviteesIds = const [],
    required this.link,
  });

  Meeting copyWith({
    String? id,
    String? title,
    String? starts,
    String? ends,
    bool? isDone,
    bool? isOnline,
    String? link,
    List? inviteesNames,
    List? inviteesIds,
    String? researchId,
  }) {
    return Meeting(
      researchId: researchId ?? this.researchId,
      id: id ?? this.id,
      title: title ?? this.title,
      starts: starts ?? this.starts,
      ends: ends ?? this.ends,
      isOnline: isOnline ?? this.isOnline,
      link: link ?? this.link,
      inviteesNames: inviteesNames ?? this.inviteesNames,
      inviteesIds: inviteesIds ?? this.inviteesIds,
    );
  }

  factory Meeting.empty() => Meeting(
        title: '',
        researchId: '',
        inviteesIds: [],
        inviteesNames: [],
        starts: DateTime.now().toString().substring(0, 16),
        ends: DateTime.now().toString().substring(11, 16),
        isOnline: false,
        link: '',
      );

  DateTime? get minimumEndDate => DateTime.tryParse(starts);

  bool contains(String id) => inviteesIds.contains(id);

  @override
  List<Object?> get props => [researchId, title, inviteesIds, starts, ends, link, isOnline];

  Meeting setEndDate(DateTime dateTime) => copyWith(ends: Formatter.formatTime(dateTime));

  Meeting setStartDate(DateTime dateTime) => copyWith(
        starts: Formatter.formatDateTime(dateTime),
        ends: Formatter.formatTime(dateTime),
      );

  Meeting setTitle(String? title) => copyWith(title: title);

  Meeting addInvitee(String id, String name) =>
      copyWith(inviteesIds: [...inviteesIds, id], inviteesNames: [...inviteesNames, name]);

  Meeting removeInvitee(String id, String name) => copyWith(
      inviteesIds: inviteesIds.where((currentId) => currentId != id).toList(),
      inviteesNames: inviteesNames.where((currentName) => currentName != name).toList());

  Meeting setLink(String link) => copyWith(link: link);

  String get invitees => parseNames(inviteesNames);

  String get meetingDuration => Formatter.formatDuration(starts, ends).toString() + " " + "minutes".tr;

  String get startDate => Formatter.parseDate(starts);
  String get endDate => ends;

  bool isAllGroupEnrollmentsSelected(List<String> ids) {
    if (ids.isEmpty) return false;
    bool isAllSelected = true;
    for (final id in inviteesIds) {
      if (contains(id) == false) isAllSelected = false;
    }

    return isAllSelected;
  }

  DateTime? get initialEndDate => minimumEndDate;

  bool isParticipantSelected(String id) => contains(id);
}
