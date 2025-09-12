import 'package:acti_buddy/features/activity/data/models/activity_comment_model.dart';
import 'package:acti_buddy/features/activity/data/models/activity_like_model.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_comment_entity.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_like_entity.dart';
import 'package:acti_buddy/features/activity/domain/repositories/activity_interaction_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityInteractionRepositoryImpl
    implements ActivityInteractionRepository {
  ActivityInteractionRepositoryImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _commentsCollection =>
      _firestore.collection('activity_comments');

  CollectionReference get _likesCollection =>
      _firestore.collection('activity_likes');

  @override
  Future<void> addComment(
    String activityId,
    String content,
    String userId,
    String userName,
  ) async {
    try {
      final commentDoc = _commentsCollection.doc();
      final comment = ActivityCommentModel(
        id: commentDoc.id,
        activityId: activityId,
        userId: userId,
        userName: userName,
        content: content,
        createdAt: DateTime.now(),
      );

      await commentDoc.set(comment.toDocument());
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  @override
  Future<List<ActivityCommentEntity>> getComments(String activityId) async {
    try {
      final querySnapshot = await _commentsCollection
          .where('activityId', isEqualTo: activityId)
          .orderBy('createdAt', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => ActivityCommentModel.fromDocument(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      await _commentsCollection.doc(commentId).delete();
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  @override
  Future<void> toggleLike(
    String activityId,
    String userId,
    String userName,
  ) async {
    try {
      final existingLike = await _likesCollection
          .where('activityId', isEqualTo: activityId)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingLike.docs.isNotEmpty) {
        // Unlike
        await existingLike.docs.first.reference.delete();
      } else {
        // Like
        final likeDoc = _likesCollection.doc();
        final like = ActivityLikeModel(
          id: likeDoc.id,
          activityId: activityId,
          userId: userId,
          userName: userName,
          createdAt: DateTime.now(),
        );

        await likeDoc.set(like.toDocument());
      }
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  @override
  Future<List<ActivityLikeEntity>> getLikes(String activityId) async {
    try {
      final querySnapshot = await _likesCollection
          .where('activityId', isEqualTo: activityId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ActivityLikeModel.fromDocument(doc).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to get likes: $e');
    }
  }

  @override
  Future<bool> isLiked(String activityId, String userId) async {
    try {
      final querySnapshot = await _likesCollection
          .where('activityId', isEqualTo: activityId)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> getLikeCount(String activityId) async {
    try {
      final querySnapshot = await _likesCollection
          .where('activityId', isEqualTo: activityId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}
