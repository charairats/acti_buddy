import 'package:acti_buddy/shared/shared.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                MyChoiceChip(
                  label: 'All',
                  selected: true,
                  onSelected: (value) {},
                ),
                const SizedBox(width: 8),
                MyChoiceChip(
                  label: 'Mentioned',
                  selected: false,
                  onSelected: (value) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
