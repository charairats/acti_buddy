// home_page.dart
import 'package:acti_buddy/acti_buddy.dart';
import 'package:acti_buddy/features/home/notifiers/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          refreshHomeAsyncNotifier.refresh();
        },
        child: ListView(
          children: [
            Text('Welcome Back, Jean!'),
            const SizedBox(height: 16),
            Center(child: const MyGradientText(text: 'Upcoming Events!')),
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
          ],
        ),
      ),
    );
  }
}
