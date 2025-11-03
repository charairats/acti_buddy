import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:acti_buddy/features/activity/presentation/providers/activity_interaction_provider.dart';
import 'package:acti_buddy/features/activity/presentation/providers/activity_participant_provider.dart';
import 'package:acti_buddy/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivityDetailPage extends ConsumerStatefulWidget {
  const ActivityDetailPage({
    super.key,
    required this.activity,
  });

  final ActivityEntity activity;

  @override
  ConsumerState<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends ConsumerState<ActivityDetailPage> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0, // เพิ่มความสูงตรงนี้ตามที่ต้องการ
            pinned: true,
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_add),
                onPressed: () {
                  // Handle favorite action
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Handle share action
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'หาเพื่อนวิ่งมาราธอนครับ งาน Bangkok Marathon',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://picsum.photos/1200/400?random=${widget.activity.id}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: สวนจตุจักร กรุงเทพฯ',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date & Time: ${DateFormat.yMMMMEEEEd().format(DateTime.parse('2025-11-15 06:00:00'))}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Participants: 3/10',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
                  ),

                  const SizedBox(height: 8),

                  Divider(height: 24, color: cs.onSurface.withAlpha(50)),
                  const SizedBox(height: 8),
                  Text(
                    '''รายละเอียดกิจกรรม: มาซ้อมวิ่งมาราธอนด้วยกัน เตรียมตัวให้พร้อมสำหรับงาน Bangkok Marathon!

🗓️ วัน/เวลาซ้อม: ทุกวันเสาร์ตอนเช้า (เวลาจะนัดหมายกันอีกครั้งในแชทกลุ่ม)

📍 สถานที่ซ้อม: สวนจตุจักร

🤝 คุณสมบัติที่ต้องการ:

มีเป้าหมายวิ่งในงาน Bangkok Marathon (หรืออยากซ้อมวิ่งจริงจังก็ได้)

มีความมุ่งมั่นและพร้อมที่จะมาซ้อมสม่ำเสมอ

📝 หมายเหตุ: เราจะเน้นการซ้อมวิ่งระยะยาวและเทมโป้ในสวนจตุจักร เพื่อสร้างความคุ้นเคยกับระยะทางและบรรยากาศ

สนใจเข้าร่วมซ้อม? กดเข้าร่วมได้เลย! มาผลักดันและให้กำลังใจกันสู่เส้นชัยครับ!''',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: cs.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // _showDialogJoinSuccess(context);
                    _showDialogJoinFailed(context);
                  },
                  label: Text('Join Now'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showDialogJoinSuccess(BuildContext context) async {
  final cs = Theme.of(context).colorScheme;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.check_circle, color: cs.primary, size: 48),
        title: Text(
          'Joined Successfully',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You have successfully joined the activity.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'View My Activities',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.surface),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'Back to Home',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    },
  );
}

Future<void> _showDialogJoinFailed(BuildContext context) async {
  final cs = Theme.of(context).colorScheme;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Icon(Icons.error, color: cs.error, size: 48),
        title: Text(
          'Join Failed',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: cs.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Unable to join the activity due to the activity being full. Please try another activity.',

              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  'Back to Results',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(
                        color: cs.surface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),

        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    },
  );
}
