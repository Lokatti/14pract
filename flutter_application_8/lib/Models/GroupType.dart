class GroupType {
  final int groupTypeId;
  final String descriptionType;
  final String groupTypeName;

  GroupType({
    required this.groupTypeId,
    required this.descriptionType,
    required this.groupTypeName,
  });

  factory GroupType.fromJson(Map<String, dynamic> json) {
    return GroupType(
      groupTypeId: json['groupTypeId'],
      descriptionType: json['descriptionType'],
      groupTypeName: json['groupTypeName'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'groupTypeId': groupTypeId,
      'descriptionType': descriptionType,
      'groupTypeName': groupTypeName,
    };
  }
}
