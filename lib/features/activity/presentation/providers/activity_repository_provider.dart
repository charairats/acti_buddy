import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ActivityRepository(firestore: firestore);
});
