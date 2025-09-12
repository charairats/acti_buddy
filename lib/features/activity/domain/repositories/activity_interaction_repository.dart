import 'package:acti_buddy/features/activity/domain/entities/activity_comment_entity.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_like_entity.dart';

abstract class ActivityInteractionRepository {
  // Comments
  Future<void> addComment(
    String activityId,
    String content,
    String userId,
    String userName,
  );
  Future<List<ActivityCommentEntity>> getComments(String activityId);
  Future<void> deleteComment(String commentId);

  // Likes
  Future<void> toggleLike(String activityId, String userId, String userName);
  Future<List<ActivityLikeEntity>> getLikes(String activityId);
  Future<bool> isLiked(String activityId, String userId);
  Future<int> getLikeCount(String activityId);
}
