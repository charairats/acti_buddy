import 'package:acti_buddy/core/providers/firestore_provider.dart';
import 'package:acti_buddy/features/search/data/search_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<SearchRepository> searchRepositoryProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return SearchRepository(firestore);
});
