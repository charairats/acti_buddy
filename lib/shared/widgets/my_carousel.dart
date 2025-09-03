import 'package:acti_buddy/acti_buddy.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyCarouselValueNotifier extends ValueNotifier<int> {
  MyCarouselValueNotifier() : super(0);

  int get activeIndex => value;

  void setActiveIndex(int index) {
    value = index;
    notifyListeners();
  }
}

class MyCarousel extends StatefulWidget {
  const MyCarousel({super.key, required this.items});

  final List<Widget> items;

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  final myCarouselValueNotifier = MyCarouselValueNotifier();
  final carouselController = CarouselSliderController();

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: widget.items.length,
          itemBuilder: (context, index, realIndex) {
            return widget.items[index];
          },
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            aspectRatio: 21 / 9,
            initialPage: 0,
            onPageChanged: (index, reason) {
              myCarouselValueNotifier.setActiveIndex(index);
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: myCarouselValueNotifier,
          builder: (context, value, child) {
            return AnimatedSmoothIndicator(
              activeIndex: value,
              count: widget.items.length,
              effect: const WormEffect(
                dotWidth: 8,
                dotHeight: 8,
                activeDotColor: kBrandYellow,
              ),
              onDotClicked: (index) {
                carouselController.animateToPage(index);
              },
            );
          },
        ),
      ],
    );
  }
}
