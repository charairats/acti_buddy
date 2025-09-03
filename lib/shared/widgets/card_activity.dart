import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String host;
  final String location;
  final String time;
  final int participants;
  final int capacity;
  // final IconData icon;

  const ActivityCard({
    super.key,
    required this.title,
    required this.host,
    required this.location,
    required this.time,
    required this.participants,
    required this.capacity,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero icon + Title
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: cs.primary.withValues(alpha: 0.2),
                  // child: Icon(icon, color: cs.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Meta info
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Host: $host", style: theme.textTheme.bodyMedium),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(location, style: theme.textTheme.bodyMedium),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(time, style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),

            // Participants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "👥 $participants/$capacity joined",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade400,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("Join"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
