import 'package:flutter/material.dart';

///Container with circular corner radius & given Child
class CustomContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double cornerRadius;
  final Color bgColor;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  const CustomContainer(
      {Key? key,
      this.width,
      this.height,
      required this.cornerRadius,
      required this.bgColor,
      this.padding,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius), color: bgColor),
        child: child);
  }
}
