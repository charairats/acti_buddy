class ActivityLikeEntity {
  ActivityLikeEntity({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  final String id;
  final String activityId;
  final String userId;
  final String userName;
  final DateTime createdAt;
}
