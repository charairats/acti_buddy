import 'package:acti_buddy/features/activity/data/repositories/browse_activity_repository_impl.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:acti_buddy/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final browseActivityRepositoryProvider = Provider<BrowseActivityRepository>((
  ref,
) {
  return BrowseActivityRepositoryImpl(
    firestore: FirebaseFirestore.instance,
  );
});

class BrowseActivitiesState {
  const BrowseActivitiesState({
    this.activities = const [],
    this.selectedCategoryId,
    this.sortType = ActivitySortType.latest,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  final List<ActivityEntity> activities;
  final String? selectedCategoryId;
  final ActivitySortType sortType;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  BrowseActivitiesState copyWith({
    List<ActivityEntity>? activities,
    String? selectedCategoryId,
    ActivitySortType? sortType,
    bool? isLoading,
    bool? hasMore,
    String? error,
    bool clearCategoryId = false, // เพิ่ม flag สำหรับ clear category
  }) {
    return BrowseActivitiesState(
      activities: activities ?? this.activities,
      selectedCategoryId: clearCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      sortType: sortType ?? this.sortType,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}

class BrowseActivitiesNotifier extends StateNotifier<BrowseActivitiesState> {
  BrowseActivitiesNotifier({
    required this.repository,
    required this.ref,
  }) : super(const BrowseActivitiesState()) {
    loadActivities();
  }

  final BrowseActivityRepository repository;
  final Ref ref;

  Future<void> loadActivities({bool refresh = false}) async {
    if (state.isLoading) return;

    print(
      'Loading activities - Category: ${state.selectedCategoryId}, Sort: ${state.sortType}',
    );

    state = state.copyWith(
      isLoading: true,
      activities: refresh ? [] : state.activities,
      hasMore: refresh ? true : state.hasMore,
      error: null,
    );

    try {
      final user = ref.read(authStateProvider).value;
      print('User: ${user?.uid}');

      final activities = await repository.browseActivities(
        categoryId: state.selectedCategoryId,
        sortType: state.sortType,
        excludeUserId: user?.uid,
        limit: 20,
      );

      print('Loaded ${activities.length} activities');

      state = state.copyWith(
        activities: refresh ? activities : [...state.activities, ...activities],
        isLoading: false,
        hasMore: activities.length == 20,
        error: null,
      );
    } catch (e) {
      print('Error loading activities: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setCategoryFilter(String? categoryId) {
    print(
      'Setting category filter: $categoryId (current: ${state.selectedCategoryId})',
    );
    if (state.selectedCategoryId != categoryId) {
      state = state.copyWith(
        selectedCategoryId: categoryId,
        clearCategoryId: categoryId == null, // ใช้ flag เมื่อต้องการ clear
        activities: [],
        hasMore: true,
        error: null,
      );
      loadActivities(refresh: true);
    }
  }

  void setSortType(ActivitySortType sortType) {
    if (state.sortType != sortType) {
      state = state.copyWith(
        sortType: sortType,
        activities: [],
        hasMore: true,
      );
      loadActivities(refresh: true);
    }
  }

  Future<void> refresh() async {
    await loadActivities(refresh: true);
  }

  Future<void> incrementViewCount(String activityId) async {
    await repository.incrementViewCount(activityId);
  }
}

final browseActivitiesProvider =
    StateNotifierProvider<BrowseActivitiesNotifier, BrowseActivitiesState>((
      ref,
    ) {
      return BrowseActivitiesNotifier(
        repository: ref.read(browseActivityRepositoryProvider),
        ref: ref,
      );
    });
