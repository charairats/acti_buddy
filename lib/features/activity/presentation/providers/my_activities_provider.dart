import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myActivitiesProvider =
    AsyncNotifierProvider<MyActivitiesNotifier, List<ActivityEntity>>(
      MyActivitiesNotifier.new,
    );

// Provider สำหรับ upcoming activities
final upcomingActivitiesProvider = Provider<List<ActivityEntity>>((ref) {
  final activities = ref.watch(myActivitiesProvider).value ?? [];
  final now = DateTime.now();
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  return activities.where((activity) {
    // ต้องไม่ถูกยกเลิก
    if (activity.cancelledAt != null) return false;

    // กิจกรรมที่เริ่มหลังจากวันนี้ (ไม่ใช่วันนี้และยังมาไม่ถึง)
    return activity.startDate.isAfter(endOfDay);
  }).toList();
});

// Provider สำหรับ today activities
final todayActivitiesProvider = Provider<List<ActivityEntity>>((ref) {
  final activities = ref.watch(myActivitiesProvider).value ?? [];
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

  return activities.where((activity) {
    // ต้องไม่ถูกยกเลิก
    if (activity.cancelledAt != null) return false;

    // ต้องไม่สิ้นสุดแล้ว (endDate ต้องยังไม่ผ่านไป)
    if (activity.endDate.isBefore(now)) return false;

    // ต้องเป็นกิจกรรมของวันนี้ (startDate หรือ endDate อยู่ในวันนี้ หรือกิจกรรมข้ามวัน)
    bool isActivityToday =
        // กิจกรรมเริ่มในวันนี้
        (activity.startDate.isAfter(
              startOfDay.subtract(const Duration(seconds: 1)),
            ) &&
            activity.startDate.isBefore(
              endOfDay.add(const Duration(seconds: 1)),
            )) ||
        // กิจกรรมสิ้นสุดในวันนี้
        (activity.endDate.isAfter(
              startOfDay.subtract(const Duration(seconds: 1)),
            ) &&
            activity.endDate.isBefore(
              endOfDay.add(const Duration(seconds: 1)),
            )) ||
        // กิจกรรมข้ามวัน (เริ่มก่อนวันนี้และสิ้นสุดหลังวันนี้)
        (activity.startDate.isBefore(startOfDay) &&
            activity.endDate.isAfter(endOfDay));

    return isActivityToday;
  }).toList();
});

// Provider สำหรับ ended activities
final endedActivitiesProvider = Provider<List<ActivityEntity>>((ref) {
  final activities = ref.watch(myActivitiesProvider).value ?? [];
  return activities.where((activity) {
    return activity.cancelledAt == null &&
        activity.endDate.isBefore(DateTime.now());
  }).toList();
});

// Provider สำหรับ cancelled activities
final cancelledActivitiesProvider = Provider<List<ActivityEntity>>((ref) {
  final activities = ref.watch(myActivitiesProvider).value ?? [];
  return activities.where((activity) => activity.cancelledAt != null).toList();
});

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
