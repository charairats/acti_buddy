import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ProfileRepositoryImpl(firestore: firestore);
});
