import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = AsyncNotifierProvider<GoogleSignInNotifier, User?>(
  GoogleSignInNotifier.new,
);

class GoogleSignInNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        // The user canceled the sign-in
        // state = AsyncValue.data(FirebaseAuth.instance.currentUser);
        // debugPrintStack(stackTrace: StackTrace.current);
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      state = AsyncValue.data(userCredential.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      debugPrint(e.toString());
      debugPrintStack(stackTrace: st);
    }
  }
}
