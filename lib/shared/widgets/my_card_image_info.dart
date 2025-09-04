import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

class MyCardImageInfo extends StatelessWidget {
  const MyCardImageInfo({
    super.key,
    this.index,
    this.title,
    this.imageUrl,
    this.isFavorite = false,
  });

  final int? index;
  final String? title;
  final String? imageUrl;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: cs.surface,
      ),
      child: Stack(
        children: [
          Container(
            height: 168,
            width: 128,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://picsum.photos/1200/400?random=$index',
                ),
                fit: BoxFit.cover,
              ),
              color: cs.surfaceContainer.withAlpha(230),
            ),
          ),
          if (isFavorite)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Make it a circle
                  color: cs.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Iconify(Bi.star_fill, color: cs.secondary, size: 20),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: cs.onPrimary.withAlpha(100),
              padding: const EdgeInsets.all(8),
              child: Expanded(
                child: Text(
                  title ?? '',
                  style: TextStyle(fontSize: 14, color: cs.secondary),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
