class ActivityCommentEntity {
  ActivityCommentEntity({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String activityId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
