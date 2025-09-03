import 'package:acti_buddy/core/router/router.dart';
import 'package:acti_buddy/core/theme/theme_data.dart';
import 'package:acti_buddy/features/profile/presentation/pages/profile_page.dart';
import 'package:acti_buddy/shared/widgets/card_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  // Preserve native splash until we decide to remove it (preview/debug use)
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ActiBuddyApp());
}

class ActiBuddyApp extends StatelessWidget {
  const ActiBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chat'));
  }
}

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Profile'));
//   }
// }

// class ActivityCard extends StatelessWidget {
//   final String title;
//   final String meta;
//   final String participants;
//   const ActivityCard({
//     super.key,
//     required this.title,
//     required this.meta,
//     required this.participants,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: theme.textTheme.displayMedium),
//             const SizedBox(height: 6),
//             Text(
//               meta,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
//               ),
//             ),
//             Text(
//               participants,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 child: const Text('Join Now'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
