// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/colorPrefs.dart';

class ShimmerLoadingContainer extends StatelessWidget {
  final Widget child;
  const ShimmerLoadingContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.shimmerBaseColor,
      highlightColor: Theme.of(context).colorScheme.shimmerHighlightColor,
      child: child,
    );
  }
}
