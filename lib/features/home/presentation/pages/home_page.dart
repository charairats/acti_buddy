// home_page.dart
import 'package:acti_buddy/acti_buddy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshHomeAsyncValue = ref.watch(refreshHomeNotifierProvider);

    ref.listen(refreshHomeNotifierProvider, (previous, next) {
      if (next is AsyncLoading) {
        MyLoading.show(context);
      } else {
        MyLoading.hide(context);
      }
    });

    return refreshHomeAsyncValue.when(
      loading: () {
        return SizedBox.shrink();
      },
      data: (data) {
        return const _WhenDataScreen();
      },
      error: (error, stackTrace) {
        return SizedBox.shrink();
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
          await refreshHomeAsyncNotifier.refresh();
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
      padding: const EdgeInsets.all(8),
      children: [
        MyQuickActionButton(
          icon: 'Bi.dribbble',
          label: 'Create an Activity',
          onTap: () {
            context.push(RoutePath.createActivity);
          },
        ),
        MyQuickActionButton(
          icon: 'Bi.calendar_heart',
          label: 'My Activities',
          onTap: () {
            const MyToast(
              type: MyToastType.success,
              message: 'Activity created successfully.',
            ).show(context);
          },
        ),
        MyQuickActionButton(icon: 'Bi.geo_alt', label: 'Activities Nearby'),
        MyQuickActionButton(icon: 'Bi.person', label: 'Report Abuse'),
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
          const SizedBox(height: 16),
          Stack(
            children: [
              Image.asset(
                'assets/images/mountain_2.png',
                fit: BoxFit.cover,
                height: 176,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                  child: Row(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: MyCardImageInfo(
                          index: index,
                          title:
                              'หาเพื่อนเดินป่า เทรลเขาช้างเผือก ทองผาภูมิเดือนตุลาคมนี้ครับ รับไม่เกิน 4 คน',

                          isFavorite: true,
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
