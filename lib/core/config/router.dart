import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class RouteName {
  static const splash = 'splash';
  static const home = 'home';
  static const search = 'search';
  static const notifications = 'notifications';
  static const profile = 'profile';
  static const settings = 'settings';
  static const signIn = 'sign_in';
}

class RoutePath {
  static const splash = '/splash';
  static const home = '/home';
  static const search = '/search';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const settings = '/settings';
  static const signIn = '/sign-in';
}

class RouteConfig {
  static final  List<RouteBase> router= [
      ShellRoute(
        builder: (context, state, child) {
          Future.microtask(FlutterNativeSplash.remove);
          return _ScaffoldShell(child: child);
        },
        routes: [
          GoRoute(
            path: RoutePath.home,
            name: RouteName.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: RoutePath.search,
            name: RouteName.search,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchActivityPage()),
          ),
          GoRoute(
            path: RoutePath.notifications,
            name: RouteName.notifications,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NotificationsPage()),
          ),
          GoRoute(
            path: RoutePath.profile,
            name: RouteName.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
      GoRoute(
        path: RoutePath.splash,
        name: RouteName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RoutePath.signIn,
        name: RouteName.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: RoutePath.settings,
        name: RouteName.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ];
}

class _ScaffoldShell extends StatefulWidget {
  final Widget child;
  const _ScaffoldShell({required this.child});
  @override
  State<_ScaffoldShell> createState() => _ScaffoldShellState();
}

class _ScaffoldShellState extends State<_ScaffoldShell> {
  static const List<String> tabs = [
    RoutePath.home,
    RoutePath.search,
    RoutePath.notifications,
    RoutePath.profile,
  ];

  int _indexFromLocation(String location) {
    final i = tabs.indexWhere((p) => location.startsWith(p));
    return i >= 0 ? i : 0;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(location);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          if (i == index) return;
          context.go(tabs[i]);
        },
        destinations: [
          NavigationDestination(
            icon: Iconify(Bi.house_door, color: cs.onSurface),
            selectedIcon: const Iconify(Bi.house_door_fill),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Iconify(Bi.search, color: cs.onSurface),
            selectedIcon: const Iconify(Bi.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Iconify(Bi.bell, color: cs.onSurface),
            selectedIcon: const Iconify(Bi.bell_fill),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Iconify(Bi.person_circle, color: cs.onSurface),
            selectedIcon: const Iconify(Bi.person_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}