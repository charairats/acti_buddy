import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class MyActivitiesPage extends ConsumerStatefulWidget {
  const MyActivitiesPage({super.key});

  @override
  ConsumerState<MyActivitiesPage> createState() => _MyActivitiesPageState();
}

class _MyActivitiesPageState extends ConsumerState<MyActivitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activitiesAsync = ref.watch(myActivitiesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activities'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          indicatorColor: theme.colorScheme.primary,
          isScrollable: true,
          tabs: [
            Tab(
              child: Text('Today'),
            ),
            Tab(
              child: Text('Upcoming'),
            ),
            Tab(
              child: Text('Ended'),
            ),
            Tab(
              child: Text('Cancelled'),
            ),
          ],
        ),
      ),
      body: activitiesAsync.when(
        data: (_) => TabBarView(
          controller: _tabController,
          children: [
            TodayActivitiesTab(parent: this),
            UpcomingActivitiesTab(parent: this),
            EndedActivitiesTab(parent: this),
            CancelledActivitiesTab(parent: this),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorView(
          error: error.toString(),
          onRetry: () => ref.refresh(myActivitiesProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => const CreateActivityPage(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showCancelDialog(ActivityEntity activity) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยกเลิกกิจกรรม'),
        content: Text('คุณต้องการยกเลิกกิจกรรม "${activity.name}" หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ไม่'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(myActivitiesProvider.notifier)
                    .cancelActivity(activity.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ยกเลิกกิจกรรมสำเร็จ'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เกิดข้อผิดพลาด: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('ยกเลิก', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(ActivityEntity activity) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลบกิจกรรม'),
        content: Text(
          'คุณต้องการลบกิจกรรม "${activity.name}" หรือไม่? การดำเนินการนี้ไม่สามารถย้อนกลับได้',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ไม่'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(myActivitiesProvider.notifier)
                    .deleteActivity(activity.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ลบกิจกรรมสำเร็จ'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เกิดข้อผิดพลาด: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showActivityDetails(ActivityEntity activity) {
    showDialog<void>(
      context: context,
      builder: (context) => ActivityDetailDialog(activity: activity),
    );
  }
}

class TodayActivitiesTab extends ConsumerWidget {
  const TodayActivitiesTab({required this.parent, super.key});

  final _MyActivitiesPageState parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(todayActivitiesProvider);

    if (activities.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(myActivitiesProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            EmptyActivitiesView(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myActivitiesProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ActivityCard(
            activity: activity,
            onCancel: () => parent.showCancelDialog(activity),
            onDelete: () => parent.showDeleteDialog(activity),
            onView: () => parent.showActivityDetails(activity),
          );
        },
      ),
    );
  }
}

class UpcomingActivitiesTab extends ConsumerWidget {
  const UpcomingActivitiesTab({required this.parent, super.key});

  final _MyActivitiesPageState parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(upcomingActivitiesProvider);

    if (activities.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(myActivitiesProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            EmptyActivitiesView(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myActivitiesProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ActivityCard(
            activity: activity,
            onCancel: () => parent.showCancelDialog(activity),
            onDelete: () => parent.showDeleteDialog(activity),
            onView: () => parent.showActivityDetails(activity),
          );
        },
      ),
    );
  }
}

class EndedActivitiesTab extends ConsumerWidget {
  const EndedActivitiesTab({required this.parent, super.key});

  final _MyActivitiesPageState parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(endedActivitiesProvider);

    if (activities.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(myActivitiesProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            EmptyActivitiesView(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myActivitiesProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ActivityCard(
            activity: activity,
            onCancel: () {}, // Cannot cancel ended activities
            onDelete: () => parent.showDeleteDialog(activity),
            onView: () => parent.showActivityDetails(activity),
          );
        },
      ),
    );
  }
}

class CancelledActivitiesTab extends ConsumerWidget {
  const CancelledActivitiesTab({required this.parent, super.key});

  final _MyActivitiesPageState parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(cancelledActivitiesProvider);

    if (activities.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(myActivitiesProvider.future),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            EmptyActivitiesView(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myActivitiesProvider.future),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ActivityCard(
            activity: activity,
            onCancel: () {}, // Cannot cancel already cancelled activities
            onDelete: () => parent.showDeleteDialog(activity),
            onView: () => parent.showActivityDetails(activity),
          );
        },
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    required this.activity,
    required this.onCancel,
    required this.onDelete,
    required this.onView,
    super.key,
  });

  final ActivityEntity activity;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = Theme.of(context).colorScheme;
    final isActive = activity.cancelledAt == null && activity.deletedAt == null;
    final isPast = activity.endDate.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: cs.surfaceContainer,
      elevation: 2,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                activity.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              ActivityDateTimeInfo(activity: activity),
              const SizedBox(height: 12),
              ActivityParticipantsInfo(activity: activity),
              const SizedBox(height: 16),
              ActivityActionButtons(
                activity: activity,
                isActive: isActive,
                isPast: isPast,
                onCancel: onCancel,
                onDelete: onDelete,
                onView: onView,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityStatusChip extends StatelessWidget {
  const ActivityStatusChip({
    required this.activity,
    super.key,
  });

  final ActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    String status;
    Color color;

    if (activity.cancelledAt != null) {
      status = 'ยกเลิกแล้ว';
      color = Colors.orange;
    } else if (activity.endDate.isBefore(DateTime.now())) {
      status = 'สิ้นสุดแล้ว';
      color = Colors.grey;
    } else if (activity.startDate.isBefore(DateTime.now())) {
      status = 'กำลังดำเนินการ';
      color = Colors.blue;
    } else {
      status = 'กำลังมา';
      color = Colors.green;
    }

    return Chip(
      label: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }
}

class ActivityDateTimeInfo extends StatelessWidget {
  const ActivityDateTimeInfo({
    required this.activity,
    super.key,
  });

  final ActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          '${_formatDate(activity.startDate)} - ${_formatDate(activity.endDate)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class ActivityParticipantsInfo extends StatelessWidget {
  const ActivityParticipantsInfo({
    required this.activity,
    super.key,
  });

  final ActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.group,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          'ผู้เข้าร่วม ${activity.participants} คน',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class ActivityActionButtons extends StatelessWidget {
  const ActivityActionButtons({
    required this.activity,
    required this.isActive,
    required this.isPast,
    required this.onCancel,
    required this.onDelete,
    required this.onView,
    super.key,
  });

  final ActivityEntity activity;
  final bool isActive;
  final bool isPast;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          onPressed: onView,
          icon: const Icon(Icons.visibility, size: 16),
          label: const Text('ดู'),
        ),
        if (isActive && !isPast) ...[
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel, size: 16, color: Colors.orange),
            label: const Text('ยกเลิก', style: TextStyle(color: Colors.orange)),
          ),
        ],
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
          label: const Text('ลบ', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class EmptyActivitiesView extends StatelessWidget {
  const EmptyActivitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(
            Bi.calendar2_x,
            size: 80,
            color: theme.colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          Text(
            'There are no activities.',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Let's create your first activity!",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'เกิดข้อผิดพลาด',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('ลองใหม่'),
          ),
        ],
      ),
    );
  }
}

class ActivityDetailDialog extends StatelessWidget {
  const ActivityDetailDialog({
    required this.activity,
    super.key,
  });

  final ActivityEntity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    activity.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ActivityStatusChip(activity: activity),
            const SizedBox(height: 16),
            _buildDetailRow(
              'คำอธิบาย',
              activity.description,
              theme,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'วันเวลาเริ่ม',
              _formatDateTime(activity.startDate),
              theme,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'วันเวลาสิ้นสุด',
              _formatDateTime(activity.endDate),
              theme,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'จำนวนผู้เข้าร่วม',
              '${activity.participants} คน',
              theme,
            ),
            if (activity.cancelledAt != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                'วันที่ยกเลิก',
                _formatDateTime(activity.cancelledAt!),
                theme,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('ปิด'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} เวลา ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} น.';
  }
}
