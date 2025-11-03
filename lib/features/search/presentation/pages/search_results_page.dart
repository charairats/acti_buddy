import 'package:acti_buddy/core/config/config.dart';
import 'package:acti_buddy/features/activity/domain/entities/activity_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchResultsPage extends ConsumerStatefulWidget {
  const SearchResultsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchResultsPageState();
}

class _SearchResultsPageState extends ConsumerState<SearchResultsPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://picsum.photos/300/300?random=1001',
                ),
              ),
              title: Text(
                'หาเพื่อนลอยกระทงครับ',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: cs.onSurface),
              ),
              subtitle: const Text(
                'เจอกันที่สวนสาธารณะ สามทุ่มครับ ผมมีกระทงให้ด้วย\nParticipant: 1/2',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.bookmark_add),
            ),
          ),
          InkWell(
            onTap: () {
              context.pushNamed(
                RouteName.activityDetail,
                extra: ActivityEntity(
                  id: 'activity1',
                  name: 'หาเพื่อนวิ่งมาราธอนครับ งาน Bangkok Marathon',
                  description: 'ซ้อมด้วยกันทุกเช้าวันเสาร์ที่สวนจตุจักรครับ',
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(const Duration(hours: 2)),
                  participants: 10,
                  createdBy: 'user1',
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/300/300?random=1002',
                  ),
                ),
                title: Text(
                  'หาเพื่อนวิ่งมาราธอนครับ งาน Bangkok Marathon',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: cs.onSurface),
                ),
                subtitle: const Text(
                  'ซ้อมด้วยกันทุกเช้าวันเสาร์ที่สวนจตุจักรครับ\nParticipant: 3/10',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.bookmark_add),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://picsum.photos/300/300?random=1003',
                ),
              ),
              title: Text(
                'หาเพื่อนเดิน trekking ค่ะ ที่ดอยอินทนนท์',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: cs.onSurface),
              ),
              subtitle: const Text(
                'ขอไม่เกิน 3 คนค่ะ หารค่าที่พักด้วยกัน\nParticipant: 2/4',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.bookmark_add),
            ),
          ),
        ],
      ),
    );
  }
}
