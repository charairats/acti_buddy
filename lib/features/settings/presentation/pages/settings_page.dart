import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            leading: Iconify(Bi.person, color: cs.onSurface),
            title: const Text('Account'),
            subtitle: const Text('Manage your account settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Iconify(Bi.translate, color: cs.onSurface),
            title: const Text('Language'),

            onTap: () {},
          ),
          ListTile(
            leading: Iconify(Bi.bell, color: cs.onSurface),
            title: const Text('Notifications'),
            subtitle: const Text('Notification preferences'),
            onTap: () {},
          ),
          ListTile(
            leading: Iconify(Bi.journal_check, color: cs.onSurface),
            title: const Text('Terms & Conditions'),
            onTap: () {},
          ),
          ListTile(
            leading: Iconify(Bi.incognito, color: cs.onSurface),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            leading: Iconify(Bi.info_circle, color: cs.onSurface),
            title: const Text('About'),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Iconify(Bi.box_arrow_right, color: cs.onSurface),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.surfaceContainer,
              foregroundColor: cs.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'v1.0.0 beta',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: cs.onSurface.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }
}
