import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshHomeNotifierProvider =
    AsyncNotifierProvider<RefreshHomeNotifier, String>(RefreshHomeNotifier.new);

class RefreshHomeNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return _fetchData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchData);
  }

  Future<String> _fetchData() async {
    // Simulate a network call or data fetching
    await Future.delayed(const Duration(seconds: 2));
    return 'Home refreshed at ${DateTime.now()}';
  }
}
