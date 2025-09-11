import 'dart:async';
import 'dart:io';

import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createActivityProvider =
    AsyncNotifierProvider<CreateActivityNotifier, void>(
      CreateActivityNotifier.new,
    );

class CreateActivityNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Return a successful state since there's no initial data to load.
    return;
  }

  Future<void> createActivity({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required int participants,
    File? imageFile,
  }) async {
    state = const AsyncValue.loading();

    // Read the required providers
    final activityRepository = ref.read(activityRepositoryProvider);
    final user = ref.read(authStateProvider).value;
    // final storageService = ref.read(storageServiceProvider);

    // Guard against an unauthenticated user
    if (user == null) {
      state = AsyncValue.error('User not authenticated', StackTrace.current);
      return;
    }

    try {
      String? imageUrl;
      if (imageFile != null) {
        // 1. Upload the image to Firebase Storage
        final imagePath =
            'activities/${user.uid}/${DateTime.now().toIso8601String()}.jpg';
        // imageUrl = await storageService.uploadFile(imageFile, imagePath);
      }
      // Create an Activity entity
      final newActivity = ActivityModel(
        id: id,
        name: title,
        description: description,
        startDate: startDate,
        endDate: endDate,
        createdBy: user.uid,
        participants: participants,
      ).toDocument();

      // Call the repository to add the activity
      await activityRepository.addActivity(newActivity);

      // Set the state to success
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // Set the state to error
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
