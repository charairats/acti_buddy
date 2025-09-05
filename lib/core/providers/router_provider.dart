import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    redirect: (context, state) {
      final isAuthenticated = authState.hasValue && authState.value != null;
      final isOnSignInPage = state.uri.toString() == RoutePath.signIn;
      final isOnLoadingPage = state.uri.toString() == RoutePath.splash;

      // If the auth state is still loading, go to the loading page.
      if (!authState.hasValue || authState.isLoading) {
        return isOnLoadingPage ? null : RoutePath.splash;
      }

      // If the user is NOT authenticated AND is NOT on the sign-in page,
      // redirect them to the sign-in page.
      if (!isAuthenticated && !isOnSignInPage) {
        return RoutePath.signIn;
      }

      // If the user IS authenticated AND IS on the sign-in page,
      // redirect them back to the home page.
      if (isAuthenticated && isOnSignInPage) {
        return RoutePath.home;
      }

      // No redirection needed, proceed to the requested path.
      return null;
    },
    // The initialLocation no longer needs conditional logic
    initialLocation: RoutePath.home,
    routes: RouteConfig.router,
  );
});
