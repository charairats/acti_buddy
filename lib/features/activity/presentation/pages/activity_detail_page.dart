import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:acti_buddy/features/activity/presentation/providers/activity_interaction_provider.dart';
import 'package:acti_buddy/features/activity/presentation/providers/activity_participant_provider.dart';
import 'package:acti_buddy/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivityDetailPage extends ConsumerStatefulWidget {
  const ActivityDetailPage({
    super.key,
    required this.activity,
  });

  final ActivityEntity activity;

  @override
  ConsumerState<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends ConsumerState<ActivityDetailPage> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity.name),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildActivityInfo(),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                  _buildLikesSection(),
                  const SizedBox(height: 24),
                  _buildCommentsSection(),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildActivityInfo() {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activity.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.activity.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Start: ${DateFormat('MMM dd, yyyy - HH:mm').format(widget.activity.startDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'End: ${DateFormat('MMM dd, yyyy - HH:mm').format(widget.activity.endDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Participants: ${widget.activity.currentParticipants}/${widget.activity.participants}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (widget.activity.isFull) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'FULL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    // Don't show join button for own activities
    if (widget.activity.createdBy == user.uid) {
      return const SizedBox.shrink();
    }

    final isUserJoinedAsync = ref.watch(
      isUserJoinedProvider(widget.activity.id),
    );

    return isUserJoinedAsync.when(
      data: (isJoined) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isJoined
                ? () => _leaveActivity()
                : (widget.activity.canJoin ? () => _joinActivity() : null),
            icon: Icon(isJoined ? Icons.exit_to_app : Icons.add),
            label: Text(isJoined ? 'Leave Activity' : 'Join Activity'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isJoined ? Colors.grey[300] : null,
              foregroundColor: isJoined ? Colors.black87 : null,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: widget.activity.canJoin ? () => _joinActivity() : null,
          icon: const Icon(Icons.add),
          label: const Text('Join Activity'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildLikesSection() {
    final likeCountAsync = ref.watch(likeCountProvider(widget.activity.id));
    final isLikedAsync = ref.watch(isLikedProvider(widget.activity.id));

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Likes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                isLikedAsync.when(
                  data: (isLiked) => IconButton(
                    onPressed: () => _toggleLike(),
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                  ),
                  loading: () => const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, __) => IconButton(
                    onPressed: () => _toggleLike(),
                    icon: const Icon(Icons.favorite_border),
                  ),
                ),
              ],
            ),
            likeCountAsync.when(
              data: (count) => Text(
                '$count ${count == 1 ? 'like' : 'likes'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              loading: () => const Text('Loading...'),
              error: (_, __) => const Text('0 likes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    final commentsAsync = ref.watch(
      activityCommentsProvider(widget.activity.id),
    );

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) {
                  return const Text(
                    'No comments yet. Be the first to comment!',
                    style: TextStyle(color: Colors.grey),
                  );
                }

                return Column(
                  children: comments
                      .map((comment) => _buildCommentItem(comment))
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error loading comments: $error'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(dynamic comment) {
    final user = ref.watch(authStateProvider).value;
    final isOwnComment = user?.uid == comment.userId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: comment.userAvatar != null
                ? NetworkImage(comment.userAvatar as String)
                : null,
            child: comment.userAvatar == null
                ? Text((comment.userName as String)[0].toUpperCase())
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat(
                        'MMM dd, HH:mm',
                      ).format(comment.createdAt as DateTime),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    if (isOwnComment) ...[
                      const Spacer(),
                      IconButton(
                        onPressed: () => _deleteComment(comment.id as String),
                        icon: const Icon(Icons.delete, size: 16),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.content as String),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _addComment(),
            icon: const Icon(Icons.send),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _joinActivity() async {
    try {
      await ref.read(joinActivityProvider(widget.activity.id).future);
      ref.invalidate(isUserJoinedProvider(widget.activity.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined activity!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join activity: $e')),
        );
      }
    }
  }

  Future<void> _leaveActivity() async {
    try {
      await ref.read(leaveActivityProvider(widget.activity.id).future);
      ref.invalidate(isUserJoinedProvider(widget.activity.id));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully left activity!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to leave activity: $e')),
        );
      }
    }
  }

  Future<void> _toggleLike() async {
    try {
      await ref.read(toggleLikeProvider(widget.activity.id).future);
      ref.invalidate(isLikedProvider(widget.activity.id));
      ref.invalidate(likeCountProvider(widget.activity.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _addComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    try {
      final params = AddCommentParams(
        activityId: widget.activity.id,
        content: content,
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
      );

      await ref.read(addCommentProvider(params).future);
      ref.invalidate(activityCommentsProvider(widget.activity.id));

      _commentController.clear();
      _commentFocusNode.unfocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add comment: $e')),
        );
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await ref
          .read(activityInteractionRepositoryProvider)
          .deleteComment(commentId);
      ref.invalidate(activityCommentsProvider(widget.activity.id));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete comment: $e')),
        );
      }
    }
  }
}
