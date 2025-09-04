import 'package:acti_buddy/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class SearchActivityPage extends StatefulWidget {
  const SearchActivityPage({super.key});

  @override
  State<SearchActivityPage> createState() => _SearchActivityPageState();
}

class _SearchActivityPageState extends State<SearchActivityPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: ListView(
        children: [
          MySearchButton(
            hintText: 'Search for Activities...',
            onTap: () {
              // Handle search button tap
            },
          ),
          const _SearchHistorySection(),
          const _TrendingHistorySection(),
          const _BrowseByCategorySection(),
          // Text(
          //   'แนะนำสำหรับคุณ (Recommended for You)',
          //   style: TextStyle(color: cs.onSurface),
          // ),
        ],
      ),
    );
  }
}

class _SearchHistorySection extends StatelessWidget {
  const _SearchHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              MyChip(label: 'เดินป่า'),
              SizedBox(width: 8.0),
              MyChip(label: 'ดูหนังผี'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingHistorySection extends StatelessWidget {
  const _TrendingHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending now',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 8.0),
          const Row(
            children: [
              MyChip(label: 'Camping'),
              SizedBox(width: 8.0),
              MyChip(label: 'Badminton'),
              SizedBox(width: 8.0),
              MyChip(label: 'Fitness'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrowseByCategorySection extends StatelessWidget {
  const _BrowseByCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse by Categories',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 8.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: [
                MyQuickActionButton(
                  icon: Bi.bicycle,
                  label: 'Sports & Outdoors',
                  // iconColor: cs.onSurface,
                ),
                const SizedBox(width: 8),
                MyQuickActionButton(
                  icon: Bi.cup_hot,
                  label: 'Food & Drinks',
                  // iconColor: cs.surface,
                ),
                const SizedBox(width: 8),
                MyQuickActionButton(
                  icon: Bi.dpad,
                  label: 'Entertain. & Recreation',
                  // iconColor: cs.surface,
                ),
                const SizedBox(width: 8),
                MyQuickActionButton(
                  icon: Bi.yin_yang,
                  label: 'Arts & Culture',
                  // iconColor: cs.surface,
                ),
                const SizedBox(width: 8),
                MyQuickActionButton(
                  icon: Bi.train_lightrail_front,
                  label: 'Travel & Tourism',
                  // iconColor: cs.surface,
                ),
                const SizedBox(width: 8),
                MyQuickActionButton(
                  icon: Bi.book,
                  label: 'Learning & Self-Improve.',
                  // iconColor: cs.surface,
                ),
                const SizedBox(width: 8),
                MyQuickActionButton(
                  icon: Bi.heart,
                  label: 'Volunteering & Social',
                  // iconColor: cs.surface,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
