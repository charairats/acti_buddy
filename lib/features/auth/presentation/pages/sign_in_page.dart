import 'package:acti_buddy/acti_buddy.dart';
import 'package:colorful_iconify_flutter/icons/logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final googleSignInAsyncValue = ref.watch(googleSignInProvider);

    ref.listen(googleSignInProvider, (previous, next) {
      if (next is AsyncLoading) {
        MyLoading.show(context);
      } else if (next is AsyncData) {
        MyLoading.hide(context);
        context.go(RoutePath.home);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Image.asset(
                AssetsImage.logo,
                width: 128,
                height: 128,
              ),
              Center(
                child: Text(
                  'Sign in to ActiBuddy',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: cs.onSurface),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Sign in to join or create activities',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: cs.onSurface),
                ),
              ),
              const SizedBox(height: 32),
              MyIconButton(
                icon: Logos.google_icon,
                label: 'Continue with Google',
                onPressed: () {
                  ref.read(googleSignInProvider.notifier).signInWithGoogle();
                },
              ),
              const SizedBox(height: 16),
              MyIconButton(
                icon: Logos.apple,
                label: 'Continue with Apple',
                onPressed: () {
                  // Handle sign-in logic
                },
              ),
              const SizedBox(height: 16),
              MyIconButton(
                icon: Bi.envelope,
                label: 'Continue with Email',
                onPressed: () {
                  // Handle sign-in logic
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'By continuing, you agree to our Terms and acknowledge that you have read our Privacy Policy.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
