import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          const _RecommendedForYouSection(),
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
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Searches',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              MyChip(label: 'เดินป่า'),
              SizedBox(width: 8),
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
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending now',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              MyChip(label: 'Camping'),
              SizedBox(width: 8),
              MyChip(label: 'Badminton'),
              SizedBox(width: 8),
              MyChip(label: 'Fitness'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrowseByCategorySection extends ConsumerWidget {
  const _BrowseByCategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityCategoriesAsyncValue = ref.watch(browseByCategoriesProvider);
    final cs = Theme.of(context).colorScheme;

    return activityCategoriesAsyncValue.when(
      data: (categories) => Padding(
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
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: MyQuickActionButton(
                          icon: category.iconName,
                          label: category.nameEnglish,
                          // iconColor: cs.onSurface,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _RecommendedForYouSection extends StatelessWidget {
  const _RecommendedForYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended for You',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: MyCardImageInfo(
              index: 1,
              title: 'ชวนกันมาเก็บขยะหาดชะอำ จังหวัดเพชรบุรี รีบก่อนเต็ม!',
              isFavorite: false,
            ),
          ),
        ],
      ),
    );
  }
}
