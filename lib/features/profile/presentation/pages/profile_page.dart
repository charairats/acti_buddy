import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/core/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ph.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          _ProfileSection(),
          SizedBox(height: 16),
          Expanded(child: _ContentSection()),
        ],
      ),
    );
  }
}

class _ProfileSection extends ConsumerWidget {
  const _ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final profileAsyncValue = ref.watch(profileProvider);

    return profileAsyncValue.when(
      data: (profile) {
        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                        // profile?.photoURL ??
                        'https://www.gravatar.com/avatar/placeholder',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.name ?? 'Unknown',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: cs.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                profile?.caption ?? '',
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push(RoutePath.settings);
                      },
                      icon: Iconify(
                        Bi.gear,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Iconify(Ph.handshake, color: cs.primary),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 8),
                          ),
                          TextSpan(
                            text:
                                '${profile?.activitiesjoined ?? 0} Connections',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Iconify(Ph.users_three, color: cs.primary),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 8),
                          ),
                          TextSpan(
                            text: '${profile?.followers ?? 0} Followers',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () {
        return const SizedBox.shrink();
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: List.generate(10, (index) {
        return Image.network('https://picsum.photos/300/300?random=$index');
      }),
    );
  }
}
