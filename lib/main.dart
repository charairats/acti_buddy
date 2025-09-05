import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Preserve native splash until we decide to remove it (preview/debug use)
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: ActiBuddyApp()));
}

class ActiBuddyApp extends ConsumerWidget {
  const ActiBuddyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coreServiceAsyncValue = ref.watch(coreServiceProvider);

    return coreServiceAsyncValue.when(
      data: (providers) {
        final router = ref.watch(routerProvider);

        return MaterialApp.router(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
      error: (err, st) => const _ErrorScreen(),
      loading: () => const _SplashScreen(),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
