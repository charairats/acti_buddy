import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  // Listen to the Firebase Auth state changes
  debugPrint('AuthStateProvider: Listening to auth state changes');
  return FirebaseAuth.instance.authStateChanges();
});
