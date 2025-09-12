import 'package:acti_buddy/features/activity/domain/entities/activity_comment_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityCommentModel {
  ActivityCommentModel({
    required this.id,
    required this.activityId,
    required this.userId,
    required this.userName,
    this.userAvatar,
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

  factory ActivityCommentModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityCommentModel(
      id: doc.id,
      activityId: data['activityId'] as String,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      userAvatar: data['userAvatar'] as String?,
      content: data['content'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'activityId': activityId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  ActivityCommentEntity toEntity() {
    return ActivityCommentEntity(
      id: id,
      activityId: activityId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
