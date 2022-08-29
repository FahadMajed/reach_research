import 'dart:convert';

import 'package:flutter/foundation.dart';

class Meeting extends ChangeNotifier {
  final String? id;
  final String title;
  final String starts;
  final String ends;

  final bool isOnline;
  final String link;
  final List inviteesNames;
  final List inviteesIds;

  Meeting({
    this.id = "",
    required this.title,
    required this.starts,
    required this.ends,
    required this.isOnline,
    this.inviteesNames = const [],
    this.inviteesIds = const [],
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'starts': starts,
      'link': link,
      'ends': ends,
      'isOnline': isOnline,
      "inviteesIds": inviteesIds,
      "inviteesNames": inviteesNames
    };
  }

  factory Meeting.fromFirestore(Map<String, dynamic> map) {
    return Meeting(
      id: map['id'] ?? '',
      title: map['title'] ?? " - ",
      starts: map['starts'] ?? DateTime.now().toString(),
      ends: map['ends'] ?? DateTime.now().toString(),
      link: map["link"] ?? "",
      inviteesIds: map["inviteesIds"] ?? [],
      isOnline: map['isOnline'] ?? false,
      inviteesNames: map["inviteesNames"] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Meeting.fromJson(String source) =>
      Meeting.fromFirestore(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Meeting &&
        other.title == title &&
        other.starts == starts &&
        other.ends == ends &&
        other.isOnline == isOnline &&
        other.link == link &&
        listEquals(other.inviteesNames, inviteesNames) &&
        listEquals(other.inviteesIds, inviteesIds);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        starts.hashCode ^
        ends.hashCode ^
        isOnline.hashCode ^
        link.hashCode ^
        inviteesNames.hashCode ^
        inviteesIds.hashCode;
  }

  void addInvitee(String inviteeId, String name) {
    inviteesIds.add(inviteeId);
    inviteesNames.add(name);
    notifyListeners();
  }

  void removeInvitee(String inviteeId, String name) {
    inviteesIds.remove(inviteeId);
    inviteesNames.remove(name);
    notifyListeners();
  }

  void updateState() => notifyListeners();

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
  }) {
    return Meeting(
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

  @override
  String toString() {
    return 'Meeting(title: $title, starts: $starts, ends: $ends, isOnline: $isOnline, link: $link, inviteesNames: $inviteesNames, inviteesIds: $inviteesIds)';
  }

  factory Meeting.empty() => Meeting(
        title: '',
        starts: '',
        ends: '',
        isOnline: false,
        link: '',
      );
}
