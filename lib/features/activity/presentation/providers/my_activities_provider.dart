import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myActivitiesProvider =
    AsyncNotifierProvider<MyActivitiesNotifier, List<ActivityEntity>>(
      MyActivitiesNotifier.new,
    );

class MyActivitiesNotifier extends AsyncNotifier<List<ActivityEntity>> {
  @override
  Future<List<ActivityEntity>> build() async {
    final user = ref.watch(authStateProvider).value;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    return _fetchMyActivities(user.uid);
  }

  Future<List<ActivityEntity>> _fetchMyActivities(String userId) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(activityRepositoryProvider);
      final result = await repository.getActivitiesByUser(userId);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          throw failure;
        },
        (activities) {
          // Filter out deleted activities
          final activeActivities = activities
              .where((activity) => activity.deletedAt == null)
              .toList();
          state = AsyncValue.data(activeActivities);
          return activeActivities;
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> cancelActivity(String activityId) async {
    try {
      final repository = ref.read(activityRepositoryProvider);
      final result = await repository.cancelActivity(activityId);

      result.fold(
        (failure) => throw failure,
        (_) {
          // Refresh the list after canceling
          ref.invalidateSelf();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteActivity(String activityId) async {
    try {
      final repository = ref.read(activityRepositoryProvider);
      final result = await repository.deleteActivity(activityId);

      result.fold(
        (failure) => throw failure,
        (_) {
          // Refresh the list after deleting
          ref.invalidateSelf();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshActivities() async {
    final user = ref.read(authStateProvider).value;
    if (user != null) {
      await _fetchMyActivities(user.uid);
    }
  }
}
