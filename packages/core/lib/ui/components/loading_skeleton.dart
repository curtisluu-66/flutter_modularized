import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    super.key,
    this.heightFactor,
    this.widthFactor,
    this.height,
    this.width,
    this.borderRadius,
  });

  final double? heightFactor;
  final double? widthFactor;
  final double? height;
  final double? width;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: Colors.white,
        ),
        height: heightFactor != null
            ? MediaQuery.of(context).size.width * heightFactor!
            : height,
        width: widthFactor != null
            ? MediaQuery.of(context).size.width * widthFactor!
            : width,
      ),
    );
  }
}
