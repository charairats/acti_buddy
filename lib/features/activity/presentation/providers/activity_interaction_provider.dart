import 'package:acti_buddy/features/activity/data/repositories/activity_interaction_repository_impl.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_comment_entity.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_like_entity.dart';
import 'package:acti_buddy/features/activity/domain/repositories/activity_interaction_repository.dart';
import 'package:acti_buddy/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityInteractionRepositoryProvider =
    Provider<ActivityInteractionRepository>((ref) {
      return ActivityInteractionRepositoryImpl(
        firestore: FirebaseFirestore.instance,
      );
    });

// Comments providers
final activityCommentsProvider =
    FutureProvider.family<List<ActivityCommentEntity>, String>((
      ref,
      activityId,
    ) async {
      final repository = ref.read(activityInteractionRepositoryProvider);
      return repository.getComments(activityId);
    });

final addCommentProvider = FutureProvider.family<void, AddCommentParams>((
  ref,
  params,
) async {
  final repository = ref.read(activityInteractionRepositoryProvider);
  await repository.addComment(
    params.activityId,
    params.content,
    params.userId,
    params.userName,
  );
});

// Likes providers
final activityLikesProvider =
    FutureProvider.family<List<ActivityLikeEntity>, String>((
      ref,
      activityId,
    ) async {
      final repository = ref.read(activityInteractionRepositoryProvider);
      return repository.getLikes(activityId);
    });

final likeCountProvider = FutureProvider.family<int, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityInteractionRepositoryProvider);
  return repository.getLikeCount(activityId);
});

final isLikedProvider = FutureProvider.family<bool, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityInteractionRepositoryProvider);
  final user = ref.read(authStateProvider).value;

  if (user == null) return false;

  return repository.isLiked(activityId, user.uid);
});

final toggleLikeProvider = FutureProvider.family<void, String>((
  ref,
  activityId,
) async {
  final repository = ref.read(activityInteractionRepositoryProvider);
  final user = ref.read(authStateProvider).value;

  if (user == null) {
    throw Exception('User not authenticated');
  }

  await repository.toggleLike(
    activityId,
    user.uid,
    user.displayName ?? 'Anonymous',
  );
});

class AddCommentParams {
  AddCommentParams({
    required this.activityId,
    required this.content,
    required this.userId,
    required this.userName,
  });

  final String activityId;
  final String content;
  final String userId;
  final String userName;
}
