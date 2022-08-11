import 'dart:convert';

import 'enroled_to.dart';

class Group {
  final String groupName;
  final String groupId;
  final List<EnrolledTo> participants;

  Group({
    required this.groupName,
    required this.participants,
    required this.groupId,
  });

  toMap() {
    return {
      'groupName': groupName,
      'groupId': groupId,
      'participants': participants.map((x) => x.toMap()).toList(),
    };
  }

  factory Group.fromFirestore(Map<String, dynamic> groupData) {
    return Group(
      groupName: groupData['groupName'] ?? '',
      groupId: groupData["groupId"] ?? "",
      participants: (groupData["participants"] as List)
          .map((v) => EnrolledTo.fromFirestore(v))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    print('Group(groupName: $groupName, groupId: $groupId,} })})');

    print("participants: ");
    participants.forEach(print);
    return "";
  }

  Group copyWith(String groupName) {
    return Group(
        groupName: groupName, participants: participants, groupId: groupId);
  }
}
