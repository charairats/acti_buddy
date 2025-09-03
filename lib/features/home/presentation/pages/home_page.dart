// home_page.dart
import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/home/notifiers/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshHomeAsyncValue = ref.watch(refreshHomeNotifierProvider);

    // ref.listen(refreshHomeAsyncNotifierProvider, (previous, next) {
    //   if (next is AsyncLoading) {
    //     MyLoading.show(context);
    //   } else {
    //     MyLoading.hide(context);
    //   }
    // });

    return refreshHomeAsyncValue.when(
      loading: () {
        return MyLoading();
      },
      data: (data) {
        return const _WhenDataScreen();
      },
      error: (error, stackTrace) {
        return SizedBox();
      },
    );
  }
}

class _WhenDataScreen extends ConsumerWidget {
  const _WhenDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshHomeAsyncNotifier = ref.read(
      refreshHomeNotifierProvider.notifier,
    );
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          refreshHomeAsyncNotifier.refresh();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Welcome Back, Jean!',
                style: TextStyle(fontSize: 24, color: cs.onSurface),
              ),
            ),

            MyCarousel(
              models: List.generate(
                5,
                (index) => MyCarouselModel(
                  imageUrl: 'https://picsum.photos/1200/400?random=$index',
                  onTap: () {
                    // Handle tap
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton.icon(
            //     onPressed: () {},
            //     label: Text('Create an Activity'),
            //     icon: Iconify(Bi.dribbble),
            //   ),
            // ),
            _QuickActionsSection(),
            const SizedBox(height: 16),
            _UpcomingSection(),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 0.95,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      children: [
        MyQuickActionButton(icon: Bi.dribbble, label: 'Create an Activity'),
        MyQuickActionButton(icon: Bi.calendar_heart, label: 'My Activities'),
        MyQuickActionButton(icon: Bi.geo_alt, label: 'Activities Nearby'),
        MyQuickActionButton(icon: Bi.person, label: 'Report Abuse'),
      ],
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        children: [
          const MyGradientText(text: 'Upcoming Events!'),
          Text(
            'Check out the latest events happening near you!',
            style: TextStyle(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
