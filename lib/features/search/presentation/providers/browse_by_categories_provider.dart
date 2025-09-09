import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final browseByCategoriesProvider =
    AsyncNotifierProvider<
      BrowseByCategoriesNotifier,
      List<ActivityCategoryEntity>
    >(
      BrowseByCategoriesNotifier.new,
    );

class BrowseByCategoriesNotifier
    extends AsyncNotifier<List<ActivityCategoryEntity>> {
  @override
  Future<List<ActivityCategoryEntity>> build() async {
    state = const AsyncValue.loading();
    final searchRepository = ref.read(searchRepositoryProvider);
    final result = await searchRepository.getAllActivityCategories();
    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (data) {
        state = AsyncValue.data(data);
      },
    );
    return state.value ?? [];
  }
}
