import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coreServiceProvider = FutureProvider<void>((ref) async {
  final sharedPrefsReady = ref.watch(sharedPrefsProvider.future);
  final storeReady = ref.watch(storeProvider.future);
  final firebaseReady = ref.watch(firebaseProvider.future);

  await Future.wait([sharedPrefsReady, storeReady, firebaseReady]);
  debugPrint('Bootstrapper: All services are initialized');

  await Future.microtask(FlutterNativeSplash.remove);
});
