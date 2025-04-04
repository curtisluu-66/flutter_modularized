import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoviePosterWidget extends StatelessWidget {
  const MoviePosterWidget({
    super.key,
    required this.poster,
    this.borderRadius,
  });

  final String? poster;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return poster?.isNotEmpty == true
        ? Hero(
            tag: poster!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 4),
              child: CachedNetworkImage(
                imageUrl: poster!,
                errorWidget: (_, __, ___) => AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 32,
                        color: Colors.black12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
