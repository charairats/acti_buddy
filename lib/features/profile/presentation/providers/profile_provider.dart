import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileEntity?>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<ProfileEntity?> {
  @override
  Future<ProfileEntity?> build() async {
    state = const AsyncValue.loading();

    try {
      final uid = ref.watch(authStateProvider).asData?.value?.uid;

      if (uid == null) {
        state = AsyncValue.error('User not authenticated', StackTrace.current);
        return null;
      }

      final profileRepository = ref.read(profileRepositoryProvider);
      final result = await profileRepository.fetchProfile(uid);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure, StackTrace.current);
          throw failure;
        },
        (data) {
          state = AsyncValue.data(data);
          return data;
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
    }
  }
}
