import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/core/ui/icons.dart';
import 'package:acti_buddy/features/activity/data/repositories/browse_activity_repository_impl.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:acti_buddy/features/activity/presentation/pages/activity_detail_page.dart';
import 'package:acti_buddy/features/activity/presentation/providers/activity_participant_provider.dart';
import 'package:acti_buddy/features/activity/presentation/providers/browse_activities_provider.dart';
import 'package:acti_buddy/features/search/presentation/providers/browse_by_categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:intl/intl.dart';

class BrowseActivitiesPage extends ConsumerStatefulWidget {
  const BrowseActivitiesPage({super.key});

  @override
  ConsumerState<BrowseActivitiesPage> createState() =>
      _BrowseActivitiesPageState();
}

class _BrowseActivitiesPageState extends ConsumerState<BrowseActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Activities'),
      ),
      body: Column(
        children: [
          // Filter and Sort Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Category Filter
                Row(
                  children: [
                    Expanded(child: _buildCategoryFilterButton()),
                    const SizedBox(width: 12),
                    _buildSortFilterButton(),
                  ],
                ),
              ],
            ),
          ),
          // Activities List
          Expanded(
            child: _buildActivitiesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterButton() {
    final categoriesAsync = ref.watch(browseByCategoriesProvider);
    final browseState = ref.watch(browseActivitiesProvider);

    return categoriesAsync.when(
      data: (categories) {
        String displayText;
        if (browseState.selectedCategoryId == null) {
          displayText = 'All Categories';
        } else {
          final selectedCategory = categories.firstWhere(
            (cat) => cat.id == browseState.selectedCategoryId,
            orElse: () => categories.first,
          );
          displayText = selectedCategory.nameEnglish;
        }

        return OutlinedButton.icon(
          onPressed: () => _showCategoryBottomSheet(categories),
          icon: Icon(Icons.category),
          label: Text(
            displayText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        );
      },
      loading: () => OutlinedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: const Text('Loading...'),
      ),
      error: (error, _) => OutlinedButton.icon(
        onPressed: () => ref.refresh(browseByCategoriesProvider),
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
      ),
    );
  }

  Widget _buildSortFilterButton() {
    final browseState = ref.watch(browseActivitiesProvider);

    return OutlinedButton.icon(
      onPressed: _showSortBottomSheet,
      icon: const Icon(Icons.sort),
      label: Text(
        browseState.sortType == ActivitySortType.latest ? 'Latest' : 'Popular',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(List<ActivityCategoryEntity> categories) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final browseState = ref.watch(browseActivitiesProvider);
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            shrinkWrap: true,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Select Category',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              // All Categories option
              ListTile(
                leading: const Icon(Icons.all_inclusive),
                title: const Text('All Categories'),
                trailing: browseState.selectedCategoryId == null
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  ref
                      .read(browseActivitiesProvider.notifier)
                      .setCategoryFilter(null);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              // Category options
              ...categories.map((category) {
                final isSelected =
                    browseState.selectedCategoryId == category.id;
                return ListTile(
                  leading: Iconify(
                    iconFromName(category.iconName),
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: Text(category.nameEnglish),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    ref
                        .read(browseActivitiesProvider.notifier)
                        .setCategoryFilter(category.id);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final browseState = ref.watch(browseActivitiesProvider);
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                'Sort By',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Latest option
              ListTile(
                leading: const Icon(Icons.schedule),
                title: const Text('Latest'),
                subtitle: const Text('Show upcoming activities first'),
                trailing: browseState.sortType == ActivitySortType.latest
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  ref
                      .read(browseActivitiesProvider.notifier)
                      .setSortType(ActivitySortType.latest);
                  Navigator.pop(context);
                },
              ),
              // Popular option
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Popular'),
                subtitle: const Text('Show most joined activities first'),
                trailing: browseState.sortType == ActivitySortType.popular
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  ref
                      .read(browseActivitiesProvider.notifier)
                      .setSortType(ActivitySortType.popular);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivitiesList() {
    final browseState = ref.watch(browseActivitiesProvider);

    // Debug print
    print(
      'Browse State - Loading: ${browseState.isLoading}, '
      'Activities count: ${browseState.activities.length}, '
      'Category: ${browseState.selectedCategoryId}, '
      'Error: ${browseState.error}',
    );

    if (browseState.isLoading && browseState.activities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (browseState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${browseState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(browseActivitiesProvider.notifier).refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (browseState.activities.isEmpty && !browseState.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No activities found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(browseActivitiesProvider.notifier).refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(browseActivitiesProvider.notifier).refresh();
      },
      child: ListView.builder(
        itemCount:
            browseState.activities.length + (browseState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == browseState.activities.length) {
            // Loading indicator for pagination
            if (browseState.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          final activity = browseState.activities[index];
          return _buildActivityCard(activity);
        },
      ),
    );
  }

  Widget _buildActivityCard(ActivityEntity activity) {
    return Card(
      color: kDarkSurfaceContainer,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          ref
              .read(browseActivitiesProvider.notifier)
              .incrementViewCount(activity.id);
          _showActivityDetails(activity);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      activity.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  _buildJoinButton(activity),
                ],
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                activity.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Activity Info
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, HH:mm').format(activity.startDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    // style: Theme.of(context).textTheme.bodySmall, --- IGNORE ---
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${activity.currentParticipants}/${activity.participants}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (activity.isFull) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'FULL',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (activity.joinCount > 0) ...[
                    Icon(Icons.favorite, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${activity.joinCount}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton(ActivityEntity activity) {
    final isUserJoinedAsync = ref.watch(isUserJoinedProvider(activity.id));

    return isUserJoinedAsync.when(
      data: (isJoined) {
        if (isJoined) {
          return ElevatedButton(
            onPressed: () => _leaveActivity(activity),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
              minimumSize: const Size(80, 32),
            ),
            child: const Text('Leave'),
          );
        }

        return ElevatedButton(
          onPressed: activity.canJoin ? () => _joinActivity(activity) : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(80, 32),
          ),
          child: const Text('Join'),
        );
      },
      loading: () => const SizedBox(
        width: 80,
        height: 32,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => ElevatedButton(
        onPressed: activity.canJoin ? () => _joinActivity(activity) : null,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(80, 32),
        ),
        child: const Text('Join'),
      ),
    );
  }

  Future<void> _joinActivity(ActivityEntity activity) async {
    try {
      await ref.read(joinActivityProvider(activity.id).future);
      ref.invalidate(isUserJoinedProvider(activity.id));
      ref.invalidate(browseActivitiesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined activity!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join activity: $e')),
        );
      }
    }
  }

  Future<void> _leaveActivity(ActivityEntity activity) async {
    try {
      await ref.read(leaveActivityProvider(activity.id).future);
      ref.invalidate(isUserJoinedProvider(activity.id));
      ref.invalidate(browseActivitiesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully left activity!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to leave activity: $e')),
        );
      }
    }
  }

  void _showActivityDetails(ActivityEntity activity) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ActivityDetailPage(activity: activity),
      ),
    );
  }
}
