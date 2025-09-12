import 'package:acti_buddy/features/activity/domain/entities/activity_like_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLikeModel {
  ActivityLikeModel({
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

  factory ActivityLikeModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLikeModel(
      id: doc.id,
      activityId: data['activityId'] as String,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'activityId': activityId,
      'userId': userId,
      'userName': userName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ActivityLikeEntity toEntity() {
    return ActivityLikeEntity(
      id: id,
      activityId: activityId,
      userId: userId,
      userName: userName,
      createdAt: createdAt,
    );
  }
}
