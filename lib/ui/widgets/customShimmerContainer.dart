// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../utils/colorPrefs.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  const CustomShimmerContainer(
      {Key? key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      height: height ?? 10,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.shimmerContentColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 10)),
    );
  }
}
